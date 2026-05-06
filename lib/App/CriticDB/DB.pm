package App::CriticDB::DB;

#use strict;
use warnings;
use Carp qw/confess/;

our $VERSION='0.0.1';

my %engines=(
	storable=>'App::CriticDB::DB::Stor',
);

sub new {
	my (undef,%opt)=@_;
	$opt{mode}//='not provided';
	my ($class,%self);
	if($opt{mode} eq 'file') {
		if(!$opt{file}) { confess('File storage requires filename') }
		$opt{type}//='storable';
		%self=map {$_=>$opt{$_}} qw/mode file type/;
		$class=$engines{$opt{type}}//$engines{storable};
		eval "require $class";
	}
	else { confess("Storage type not available:  $opt{mode}") }
	my $self=bless(\%self,$class);
	$self->read();
	return $self;
}

sub _initStore {
	my ($self)=@_;
	return (
		version=>1001,
		file=>{},
	);
}

sub _init {
	my ($self)=@_;
	%{$$self{store}}=$self->_initStore();
	return $self->write();
}

sub _fileNewer {
	my ($self,$fn,$ts)=@_;
	if(!-e $fn) { return }
	return (stat($fn))[9]>$ts;
}

sub _violation {
	my ($self,$fn,$V)=@_;
	my %res;
	my %remap=(
		'_description'  =>'desc',
		'_explanation'  =>'expl',
		'_policy'       =>'policy',
		'_severity'     =>'sev',
		'_source'       =>'code',
	);
	if('Perl::Critic::Violation' eq ref($V)) {
		%res=(
			(map {$remap{$_}=>$$V{$_}} keys(%remap)),
			line  =>$V->line_number(),
			col   =>$V->column_number(),
		)
	}
	elsif('HASH' eq ref($V)) { %res=%$V }
	else { confess('Invalid type of violation') }
	delete($res{file}); # not needed in the stored violation
	return %res;
}

sub store {
	my ($self,%opt)=@_;
	if(!$opt{file}) { return $self }
	my @violations=map {+{$self->_violation($opt{file},$_)}} @{$opt{violations}//[]};
	$$self{store}{file}{$opt{file}}{violations}=\@violations;
	$$self{store}{file}{$opt{file}}{mtime}=time();
	return $self;
}

sub flush {
	my ($self,$fn)=@_;
	return $self->write(fn=>$fn);
}

sub newer {
	my ($self,$fn)=@_;
	if(!$$self{store}{file}{$fn}) { return 1 }
	return $self->_fileNewer($fn,$$self{store}{file}{$fn}{mtime}//0);
}

sub read  { confess('Unimplemented abstract') }
sub write { confess('Unimplemented abstract') }

1;

__END__


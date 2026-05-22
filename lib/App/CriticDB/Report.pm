package App::CriticDB::Report;

use strict;
use warnings;
use Perl::Critic::Violation;

sub new {
	my ($ref,%opt)=@_;
	my $class=ref($ref)||$ref;
	my $self=bless({
		format=>undef,
		%opt,
		violations=>$opt{violations},
		},$class);
	$$self{verbose}//="%f: %m at line %l, column %c.  (Severity: %s)\n";
	Perl::Critic::Violation::set_format($$self{verbose});
	return $self;
}

sub text {
	my ($self,$violation)=@_;
	my @violations;
	if($violation) { @violations=($violation) }
	else           { @violations=@{$$self{violations}} }
	return join('',map {$_->to_string()} @violations);
}

1;

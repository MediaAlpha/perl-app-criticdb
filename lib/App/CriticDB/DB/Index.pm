package App::CriticDB::DB::Index;

use strict;
use warnings;
use Carp qw/confess/;

my %vtypes=(
	id =>'App::CriticDB::DB::Index::Id',
	set=>'App::CriticDB::DB::Index::Set',
);

sub new {
	my ($ref,%opt)=@_;
	$opt{values}//='id';
	my $type=$vtypes{$opt{values}};
	if(!$type) { confess("Invalid index type requested:  $opt{values}") }
	return bless({%opt},$type)->init();
}

sub import {
	foreach my $pkg (values %vtypes) { eval "require $pkg;" }
}

1;

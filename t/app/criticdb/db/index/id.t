#!/usr/bin/perl

use strict;
use warnings;
use App::CriticDB::DB::Index;
use Test::More tests=>3;

subtest 'initialization'=>sub{
	plan tests=>2;
	my $index=App::CriticDB::DB::Index->new(values=>'id',prefix=>'p:');
	ok(defined($index),'Created');
	is($$index{prefix},'p:','Prefix');
};

subtest 'insertion'=>sub{
	plan tests=>5;
	my $index=App::CriticDB::DB::Index->new(values=>'id',prefix=>'p:');
	my $one=$index->upsert('one');
	my $two=$index->upsert('two');
	is($index->value('unprefixed'),'unprefixed','Unprefixed');
	is($one,'p:1','Indexed entry:  one');
	is($two,'p:2','Indexed entry:  two');
	is($index->value($one),'one','Indexed value:  one');
	is($index->value($two),'two','Indexed value:  two');
};

subtest 'unprefixed'=>sub{
	plan tests=>5;
	my $index=App::CriticDB::DB::Index->new(values=>'id');
	my $one=$index->upsert('one');
	my $two=$index->upsert('two');
	is($index->value('unprefixed'),'unprefixed','Unprefixed');
	is($one,'1','Indexed entry:  one');
	is($two,'2','Indexed entry:  two');
	is($index->value($one),'one','Indexed value:  one');
	is($index->value($two),'two','Indexed value:  two');
};

# overlap
# removal

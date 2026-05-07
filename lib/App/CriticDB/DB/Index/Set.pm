package App::CriticDB::DB::Index::Set;
use parent 'App::CriticDB::DB::Index';

sub init {
	my ($self)=@_;
	%$self=(kset=>{});
	return $self;
}

sub add {
	my ($self,$ka,$kb)=@_;
	$$self{kset}{$ka}{$kb}=undef;
	return $self;
}

sub all {
	my ($self,$ka,$kb)=@_;
	my @res;
	if(defined($ka)) {
		if(!defined($kb)) { push @res,keys(%{$$self{kset}{$ka}}) }
		elsif(exists($$self{kset}{$ka}{$kb})) { push @res,[$ka,$kb] }
	}
	else {
		if(!defined($kb)) {
			while(my ($k,$va)=each %{$$self{kset}}) {
				push @res,map {[$k,$_]} keys(%$va) } }
		else { push @res,grep {exists($$self{kset}{$_}{$kb})} keys(%{$$self{kset}}) }
	}
	return @res;
}

sub remove {
	my ($self);
	return;
}

1;

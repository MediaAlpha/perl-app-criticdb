package App::CriticDB::DB::Index::Id;
use parent 'App::CriticDB::DB::Index';

sub init {
	my ($self)=@_;
	%$self=(prefix=>$$self{prefix}//'',kv=>{''=>0},vk=>['']);
	return $self;
}

sub upsert {
	my ($self,$key,$idx)=@_;
	if(defined($key)) {
		if(defined($$self{kv}{$key})) { return $$self{kv}{$key} }
		$key="$key";
		$idx=$$self{prefix}.(1+$#{$$self{vk}});
		push @{$$self{vk}},$key;
		$$self{kv}{$key}=$idx;
		return $idx;
	}
	elsif(defined($idx)) { return $$self{vk}[$idx] }
	else { return }
}

sub value {
	my ($self,$value)=@_;
	if($value=~/^\Q$$self{prefix}\E(?<idx>\d+)/) { return $$self{vk}[$+{idx}] }
	return $value;
}

sub remove {
	my ($self);
	return;
}

1;

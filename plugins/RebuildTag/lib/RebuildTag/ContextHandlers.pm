# $Id$

package RebuildTag::ContextHandlers;

use strict;
use warnings;
use Data::Dumper;
use Data::Dump qw/dump/;

sub plugin {
    return MT->component('RebuildTag');
}

sub _log {
    my ($msg) = @_;
    return unless defined($msg);
    my $prefix = sprintf "%s:%s:%s: %s", caller();
    $msg = $prefix . $msg if $prefix;
    use MT::Log;
    my $log = MT::Log->new;
    $log->message($msg) ;
    $log->save or die $log->errstr;
    return;
}


sub rebuild { #{{{
    my ($ctx, $args) = @_;

    my $target_template_ids_string = $args->{'template_ids'};
    my $force_rebuild = $args->{'force_rebuild'};
    return unless $target_template_ids_string;
    my $self_template_id = $ctx->{'__stash'}{'template'}{'column_values'}{'id'};
    my @target_ids = split(/, */, $target_template_ids_string);
    my @target_template_ids;
    foreach my $id (@target_ids){
        push(@target_template_ids,$id) if ($id ne $self_template_id);
    }

    use MT::Template;
    use MT::FileInfo;
    use MT::WeblogPublisher;
    foreach my $id (@target_template_ids) {
        my $tmpl = MT::Template->load($id);
        next unless ($tmpl);
        my $tmpl_blog_id = $tmpl->blog_id;
        #next if ($blog_id != $tmpl_blog_id);
        my @fileinfos = MT::FileInfo->load({template_id=>$id});
        next if (! @fileinfos);
        foreach my $fileinfo (@fileinfos) {
            my $file = $fileinfo->file_path;
            unlink($file) if $force_rebuild;
            my $wp = MT::WeblogPublisher->new;
            $wp->rebuild_from_fileinfo($fileinfo);
        }
    }
}

sub rebuild_entries { #{{{
    my ($ctx, $args) = @_;

    my $target_entry_ids_string = $args->{'ids'};
    my $force_rebuild = $args->{'force_rebuild'};
    return unless $target_entry_ids_string;
    my $self_entry_id = $ctx->{'__stash'}->{'entry'}->{'column_values'}->{'id'};
    MT->log({message => $self_entry_id});
    my @target_ids = split(/, */, $target_entry_ids_string);
    my @target_entry_ids;
    foreach my $id (@target_ids){
        push(@target_entry_ids,$id) if ($id ne $self_entry_id);
    }

    use MT::Template;
    use MT::FileInfo;
    use MT::WeblogPublisher;
    foreach my $id (@target_entry_ids) {
        my $tmpl = MT::Template->load($id);
        next unless ($tmpl);
        my $tmpl_blog_id = $tmpl->blog_id;
        my @fileinfos = MT::FileInfo->load({    entry_id     => $id,
                                                archive_type => 'Individual'});
        next if (! @fileinfos);
        foreach my $fileinfo (@fileinfos) {
            my $file = $fileinfo->file_path;
            unlink($file) if $force_rebuild;
            my $wp = MT::WeblogPublisher->new;
            $wp->rebuild_from_fileinfo($fileinfo);
        }
    }
}
1;


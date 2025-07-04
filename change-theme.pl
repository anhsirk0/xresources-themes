#! /usr/bin/env perl

my $dir = $ENV{HOME} . "/.config/xresources-themes";
my $config = $ENV{HOME} . "/.Xresources";
my $theme;

my $config_content;
if (scalar @ARGV > 0) {
    my @all_themes = split "\n", `ls $dir/colors`;
    @all_themes = sort { length($a) <=> length($b) } @all_themes;

    ($theme) = grep /$ARGV[0]/i, @all_themes;
    if ($theme) {
        print "$theme theme selected\n";
    } else {
        print "No theme found for \'$ARGV[0]\'\n"; 
    }
}

unless($theme) {
    $theme = `ls $dir/colors | fzf`;
    chomp $theme;
}

if ($theme) {
    # read config
    open(FH, '<' . $config) or die "Unable to open\n";
    while(<FH>) {
        if ($_ =~ m/.config\/xresources-themes\/colors/ && !($_ =~ m/^!/)) {
            $config_content .= qq{#include ".config/xresources-themes/colors/$theme"\n};
            next;
        }
        $config_content .= $_;
    }
    close(FH);
    # write config
    open(FH, '>' . $config) or die "Unable to open\n";
    print FH $config_content;
    close(FH);
} else {
    print "No theme selected\n";
}


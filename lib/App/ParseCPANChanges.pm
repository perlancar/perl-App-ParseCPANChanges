package App::ParseCPANChanges;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;

our %SPEC;

$SPEC{parse_cpan_changes} = {
    v => 1.1,
    summary => 'Parse CPAN Changes file',
    args => {
	file => {
	    schema => 'filename*',
	    summary => 'If not specified, will look for file called '.
		'Changes/ChangeLog in current directory',
	    pos => 0,
	},
        class => {
            schema => 'perl::modname*',
            default => 'CPAN::Changes',
        },
        unbless => {
            summary => 'Whether to return Perl objects as unblessed refs',
            schema => 'bool*',
            default => 1,
            description => <<'_',

If you set this to false, you'll need to use an output format that can handle
serializing Perl objects, e.g. on the CLI using `--format=perl`.

_
        },
    },
};
sub parse_cpan_changes {
    require Data::Structure::Util;

    my %args = @_;
    my $unbless = $args{unbless} // 1;
    my $class = $args{class} // 'CPAN::Changes';
    (my $class_pm = "$class.pm") =~ s!::!/!g;
    require $class_pm;

    my $file = $args{file};
    if (!$file) {
	for (qw/Changes ChangeLog/) {
	    do { $file = $_; last } if -f $_;
	}
    }
    return [400, "Please specify file ".
                "(or run in directory where Changes file exists)"]
        unless $file;

    my $ch = $class->load($file);
    [200, "OK", $unbless ? Data::Structure::Util::unbless($ch) : $ch];
}

1;
# ABSTRACT:

=head1 DESCRIPTION

This distribution provides a simple command-line wrapper for
L<CPAN::Changes>. See L<parse-cpan-changes> for more details.


=head1 SEE ALSO

L<CPAN::Changes>

L<CPAN::Changes::Spec>

An alternative way to manage your Changes using INI master format:
L<Module::Metadata::Changes>.

Dist::Zilla plugin to check your Changes before build:
L<Dist::Zilla::Plugin::CheckChangesHasContent>,
L<Dist::Zilla::Plugin::CheckChangeLog>.

=cut

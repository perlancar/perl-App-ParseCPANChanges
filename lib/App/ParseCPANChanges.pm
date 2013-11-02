package App::ParseCPANChanges;

use 5.010001;
use strict;
use warnings;

# VERSION

our %SPEC;

$SPEC{parse_cpan_changes} = {
    v => 1.1,
    summary => 'Parse CPAN Changes file',
    args => {
	file => {
	    schema => 'str*',
	    summary => 'If not specified, will look for file called '.
		'Changes/ChangeLog in current directory',
	    pos => 0,
	},
    },
};
sub parse_cpan_changes {
    require CPAN::Changes;
    require Data::Structure::Util;

    my %args = @_;

    my $file = $args{file};
    if (!$file) {
	for (qw/Changes ChangeLog/) {
	    do { $file = $_; last } if -f $_;
	}
    }
    return [400, "Please specify file ".
                "(or run in directory where Changes file exists)"]
        unless $file;

    my $ch = CPAN::Changes->load($file);
    [200, "OK", Data::Structure::Util::unbless($ch)];
}

1;
# ABSTRACT: Parse CPAN Changes file

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

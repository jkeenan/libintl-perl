#! /bin/false

# vim: tabstop=4
# $Id: gettext_xs.pm,v 1.4 2004/01/08 17:25:57 guido Exp $

# Pure Perl implementation of Uniforum message translation.
# Copyright (C) 2002-2004 Guido Flohr <guido@imperia.net>,
# all rights reserved.

# This program is free software; you can redistribute it and/or modify it
# under the terms of the GNU Library General Public License as published
# by the Free Software Foundation; either version 2, or (at your option)
# any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Library General Public License for more details.

# You should have received a copy of the GNU Library General Public
# License along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307,
# USA.

# This module is based on work done by Phillip Vandry <vandry@Mlink.NET>,
# done for Locale::gettext.

package Locale::gettext_xs;

require DynaLoader;
require Exporter;

use vars qw (%EXPORT_TAGS @EXPORT_OK @ISA);

%EXPORT_TAGS = (locale_h => [ qw (
								  gettext
								  dgettext
								  dcgettext
								  ngettext
								  dngettext
								  dcngettext
								  textdomain
								  bindtextdomain
								  bind_textdomain_codeset
								  )
							  ],
				libintl_h => [ qw (LC_CTYPE
								   LC_NUMERIC
								   LC_TIME
								   LC_COLLATE
								   LC_MONETARY
								   LC_MESSAGES
								   LC_ALL)
							   ],
				);

@EXPORT_OK = qw (gettext
				 dgettext
				 dcgettext
				 ngettext
				 dngettext
				 dcngettext
				 textdomain
				 bindtextdomain
				 bind_textdomain_codeset
                                 nl_putenv
				 LC_CTYPE
				 LC_NUMERIC
				 LC_TIME
				 LC_COLLATE
				 LC_MONETARY
				 LC_MESSAGES
				 LC_ALL);
@ISA = qw (Exporter DynaLoader);

bootstrap Locale::gettext_xs;

require File::Spec;

# Wrapper function that converts Perl paths to 
sub bindtextdomain ($;$)
{
	my ($domain, $directory) = @_;

	if (defined $domain && length $domain && 
		defined $directory && length $directory) {
		return Locale::gettext_xs::_bindtextdomain 
			($domain, File::Spec->catdir ($directory));
	} else {
		return &Locale::gettext_xs::_bindtextdomain;
	}
}

sub nl_putenv ($)
{
    my ($envspec) = @_;
    
    return unless defined $envspec;
    return unless length $envspec;
    return if substr ($envspec, 0, 1) == '=';
    
    my ($var, $value) = split /=/, $envspec, 2;
    
    if ($^O eq 'MSWin32') {
        $value = '' unless defined $value;
        return unless Locale::gettext_xs::_nl_putenv ("$var=$value") == 0;
        if (length $value) {
            $ENV{$var} = $value;
        } else {
            delete $ENV{$var};
        }
    } else {
        if (defined $value) {
            $ENV{$var} = $value;
        } else {
            delete $ENV{$var};
        }
    }

    return 1;
}

1;

__END__

Local Variables:
mode: perl
perl-indent-level: 4
perl-continued-statement-offset: 4
perl-continued-brace-offset: 0
perl-brace-offset: -4
perl-brace-imaginary-offset: 0
perl-label-offset: -4
tab-width: 4
End:


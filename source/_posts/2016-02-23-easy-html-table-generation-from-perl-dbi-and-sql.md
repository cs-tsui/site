---
layout: post
title: "Easy HTML Table Generation from Perl DBI and SQL"
date: 2016-02-23 22:17:32 -0500
comments: true
categories: Perl
---

The following script is used to quickly generate HTML tables for reports using only a SQL query as an input. Useful if you needed to generate and send out a report quickly without installing yet yet another package. 

{% codeblock lang:perl %}
#!/usr/bin/perl

use DBI;

# Query as in input, and generate HTML table output 
my $query = 'select * from data';

# 1) Connect and get DB handle
my $dbh = connect_db(); # use your own connection here
 
# 2) Run your query 
my $sth   = $dbh->prepare($query);
my @loh   = @{ $sth->fetchall_arrayref({}) }; 
my @cols  = @{ $sth->{NAME} };

# 3) Generate HTML Table 
my $thead = join('', map {"<td>$_</td>"} @cols);

my @rows = ();
for my $hr (@loh) {
    push @rows, join('', map {"<td>$_</td>"} @{$hr}{@cols});
}

my $tbody = join ('', map {"<tr>$_</tr>"} @rows);

my $html = qq|<table> $thead <thead> $thead </thead> <tbody> $tbody </tbody> </table>|;

print $html;

exit 0;

{% endcodeblock %}

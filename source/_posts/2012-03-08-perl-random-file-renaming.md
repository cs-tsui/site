---
layout: post
title: ! 'Random File Renaming - [Updated]'
categories:
- Perl
tags:
- perl
- programming
- random
- renaming
- script
status: publish
type: post
published: true
author: Chun Sing Tsui
---
<p><strong>Update:</strong> wrote an undo script that allows you undo the renaming once.</p>
<p>Small script I wrote in Perl for renaming files in the current directory to a random number based on the file extension, useful for randomizing images for slide show purposes.</p>
<p>Simply modify the @extensionArray if you want to add/remove extensions to check against.</p>

{% codeblock lang:perl %}
#!/usr/local/bin/perl

#-----------------------------------------------------
# Script to rename files with a random number if 
# extension matches 
#
# Updated: uses a different comparison: now checks 
# for exact match ignoring case
#
# Updated: outputs a file for undo feature
#-----------------------------------------------------

## Define Variable ##
@files = <*>;

#Array variable to hold extensions you may check
@extensionArray = ("jpg", "zip");

#Variable for the largest value of the random #
$randNumCeiling = 100000;

#Simple file counter to keep track of # of files processed
$numFilesRenamed = 0;

#Open a file for writing undo info
open(UNDOFILE, '>_undo_')or die "$!";;

#-----------------------------------------------------
# Loop through all files in the directory
#-----------------------------------------------------
# If it is a file, get the extension
# Checks if the extension is equal to wanted 
# extension(s)
#
# If match, generate random number for filename 
# and rename it
#-----------------------------------------------------
foreach $file (@files)
{
    if (-f $file) {
        # find and ignore all characters that is not a dot, then get the rest
        my $ext = ($file =~ m/([^.]+)$/)[0];

        if(extensionMatch($ext) ) {
            $numFilesRenamed++;
            print "($numFilesRenamed)\n";
            #Old file name
            print UNDOFILE "$file:";
            print "Old file name: $file\n";
            my $newName = int(rand($randNumCeiling));
            rename($file, "$newName.$ext");
            #New file name
            print "New file name: $newName.$ext\n\n";
            print UNDOFILE "$newName.$ext\n";
        }
    }
}
close UNDOFILE;

#-----------------------------------------------------
# Loop through extention array (defined a the top)
# to check for match with the argment passed into
# the function (which is the extension of the file
# currently being processed
#-----------------------------------------------------
# Returns a 1 if extensions match
# else returns 0
#-----------------------------------------------------
sub extensionMatch
{
    $passedInExt = @_[0];
    foreach $extension (@extensionArray){
        #check for exact string ignoring case
        if($extension =~ m/^$passedInExt$/i){
            return 1;
        }
    }
    return 0;
}

{% endcodeblock %}

<!-- more -->
<h2>Undo</h2>

{% codeblock lang:perl %}

#!/usr/local/bin/perl

#-----------------------------------------------------
# Script to undo the renaming of files using the 
# random file rename script. Simple rename back to the
# original name according to the _undo_ text file
#-----------------------------------------------------

# Opens the file for reading
open (UNDOFILE, '_undo_') or die "Cannot open undo file.";
while (<UNDOFILE>)
{
    #Split up the names
    @values = split(":", $_);
    #Get the names
    $oldname = @values[0];
    $currentname = @values[1];
    chomp($currentname);
    #Rename back to the old name
    #In this case, old name is the new name
    rename($currentname, $oldname);
}
close UNDOFILE;

{% endcodeblock %}

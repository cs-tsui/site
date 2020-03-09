---
layout: post
title: ! 'Finding Duplicate Files'
categories:
- Perl
tags:
- duplicate files
- perl
- programming
- script
status: publish
type: post
published: true
author: Chun Sing Tsui
---
<p>Another script I wrote to learn more about Perl. I used a script found on <a href="http://www.perlmonks.org/?node_id=49198">PerlMonks</a> as a starting point, and modified it with an additional function of moving all duplicate files into a folder. Again, it is heavily commented to help myself understand the code while I'm writing it.</p>

{% codeblock lang:perl %}
#!/usr/bin/perl
use Cwd;
use File::Find;
use Digest::MD5;

#-----------------------------------------------------
# This is a script for finding duplicate files in the 
# current directory. It checks for the same file size. 
# If file sizes are different, then files are 
# different. If file sizes are the same, it goes on 
# to check for the MD5 value to determine uniqueness. 
# If MD5 matches, move duplicate files to a folder
#-----------------------------------------------------
# Get current working directory and create duplicate folder directory
$currentDir = cwd();
$dupFolder  = "duplicates";
$dupDir = $currentDir."/".$dupFolder;

# Hash to store filesize as key and an array of filenames as value
%filesSizeHash  = ();
$duplicateCount = 0;
$totalDupSize   = 0;

# Using the file() function, it calls the wanted() function on every 
# file in the current directory

find(\&check_each_file, $currentDir);

# Loop to first find files of the same file size; 
# if there are multiple, check MD5values
foreach my $size (sort {$b <=> $a} keys %filesSizeHash) {
    # Process next filesize unless there are more than one value in
    next unless @{$filesSizeHash{$size}} > 1;
    #print($size."\n");

    # Hash to store MD5 values as key and an array of filenames as value
    my %fileMD5Hash = ();

    # Loop through and get MD5 and store for each file with same size
    foreach my $file (@{$filesSizeHash{$size}}) {
        open(FILE, $file) or next;
        binmode(FILE);
        my $ctx = Digest::MD5->new->addfile(*FILE);
        push @{$fileMD5Hash{$ctx->hexdigest}},$file;
    }

    # Now, take care of file if more than one file has same MD5
    foreach my $hash (keys %fileMD5Hash) {
        next unless @{$fileMD5Hash{$hash}} > 1;
        unless (-d $dupDir){mkdir $dupDir or die;}

        # There are duplicate files to deal with from this point
        # Until the currently accessed array inside the md5 hash has only
        # one item(file), move file into a different directory
        my $count = @{$fileMD5Hash{$hash}};
        for($i = 0; $i < $count-1; $i++){
            $duplicateCount++;
            my $fileName = @{$fileMD5Hash{$hash}}[$i];
            rename($fileName, $dupDir."/".$fileName);
            $totalDupSize = $totalDupSize + $size;
            print("[File moved]: $fileName\n");
        }
    }
}

# Loop to first find files of the same file size; if multiple, check MD5values
$totalDupSize = size_format($totalDupSize);
print("\n[Total number of duplicates found]: $duplicateCount\n");
print("[Toal size of duplicate files]:     $totalDupSize\n");

# Function that is called on every file in the directory of the find() function
sub check_each_file{
    #If the current "file" is a file...
    if (-f) {
        # Get  current file's name
        $currentFileName = $File::Find::name;

        # Get current file's size in bytes
        my $filesize = (stat($currentFileName))[7];

        # Push the file into an hash of arrays declared at the top,
        # with filesize as key and an array of filenames as value
        push( @{ $filesSizeHash {$filesize}}, $_);
    }
}

# Function for formatting the total output size of duplicate files
sub size_format{
   my $size = shift(@_);

   if ($size < 1024) {
      return $size . " bytes";
   }
   if ($size < (1024*1024)) {
      return sprintf("%.2f KB",$size / 1024);
   }
   if ($size < (1024*1024*1024)) {
      return sprintf("%.2f MB",$size / (1024*1024));
   }
   return sprintf("%.2f GB",$size / (1024*1024*1024));
}
{% endcodeblock %}



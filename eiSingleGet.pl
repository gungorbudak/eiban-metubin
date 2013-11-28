#!/usr/bin/perl -w

# eiSingleGet.pl (Exon/Intron Single Get)

# EIBAN - Exon/Intron Boundaries Analysis for GC Content in Human Evolution
# GUNGOR BUDAK - gngrbdk@gmail.com
# Supervisor: ASSIST. PROF. YESIM AYDIN SON - yesim@metu.edu.tr
# MIDDLE EAST TECHNICAL UNIVERSITY, ANKARA, TURKEY

# This script is used to get exons and introns from Ensembl databases
# using a single Ensembl gene ID given as an argument and generate
# a fasta file with headers containing gene, transcript and exon ID
# information and sequences of all

use strict;
use Bio::EnsEMBL::Registry;

my $registry = "Bio::EnsEMBL::Registry";
$registry->load_registry_from_db(-host => 'ensembldb.ensembl.org', -user => 'anonymous');
my $gene_adaptor  = $registry->get_adaptor('Homo sapiens', 'Core', 'Gene');
my $gene_id = $ARGV[0]; # Get Ensembl Gene ID as the first argument supplied in command line
my $gene = $gene_adaptor->fetch_by_stable_id($gene_id);
my $project_dir = '/home/gungor/projects/eiban'; # Project directory containing (Perl) scripts

open(my $outf, '>', $project_dir.'/'.$gene_id.'.fasta') or die $!;
if ($gene) { # if gene in not empty
	foreach my $transcript (@{ $gene->get_all_Transcripts }) {
		if ($transcript) { # if transcript in not empty
			my $count = 1;
			foreach my $exon (@{ $transcript->get_all_Exons }) {
				if ($exon) { # if exon in not empty
					print $outf ">ex_".$count, ";", $exon->stable_id, ";", $transcript->stable_id, ";", $gene->stable_id, "\n";
					print $outf $exon->seq->seq(), "\n";
					$count++;
					} # end if exon
				} # end foreach exon
			$count = 1;
			foreach my $intron (@{ $transcript->get_all_Introns }) {
				if ($intron) { # if intron in not empty
					print $outf ">in_".$count, ";no_id;", $transcript->stable_id, ";", $gene->stable_id, "\n";
					print $outf $intron->seq(), "\n";
					$count++;
					} # end if intron
				} # end foreach intron
			} # end if transcript
		} # end foreach transcript
	} # end if gene
close $outf;

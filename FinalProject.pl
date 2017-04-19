#!c:\strawberry\perl\bin\perl.exe

# program: project.pl
# date:    march 9, 2017
# author:  danny abesdris
# purpose: bif724 assignment #2/final project primer

use strict;
use warnings;

use Tk;
use LWP::Simple;
use Email::Send;
use Email::Send::Gmail;
use Email::Simple::Creator;

use Bio::DB::GenBank;

require Tk::Dialog;
require Tk::ROText;

my $sampleGenbank = <<'_END_';
LOCUS       SCU49845     5028 bp    DNA             PLN       21-JUN-1999
DEFINITION  Saccharomyces cerevisiae TCP1-beta gene, partial cds, and Axl2p
            (AXL2) and Rev7p (REV7) genes, complete cds.
ACCESSION   U49845
VERSION     U49845.1  GI:1293613
KEYWORDS    .
SOURCE      Saccharomyces cerevisiae (baker's yeast)
  ORGANISM  Saccharomyces cerevisiae
            Eukaryota; Fungi; Ascomycota; Saccharomycotina; Saccharomycetes;
            Saccharomycetales; Saccharomycetaceae; Saccharomyces.
REFERENCE   1  (bases 1 to 5028)
  AUTHORS   Torpey,L.E., Gibbs,P.E., Nelson,J. and Lawrence,C.W.
  TITLE     Cloning and sequence of REV7, a gene whose function is required for
            DNA damage-induced mutagenesis in Saccharomyces cerevisiae
  JOURNAL   Yeast 10 (11), 1503-1509 (1994)
  PUBMED    7871890
REFERENCE   2  (bases 1 to 5028)
  AUTHORS   Roemer,T., Madden,K., Chang,J. and Snyder,M.
  TITLE     Selection of axial growth sites in yeast requires Axl2p, a novel
            plasma membrane glycoprotein
  JOURNAL   Genes Dev. 10 (7), 777-793 (1996)
  PUBMED    8846915
REFERENCE   3  (bases 1 to 5028)
  AUTHORS   Roemer,T.
  TITLE     Direct Submission
  JOURNAL   Submitted (22-FEB-1996) Terry Roemer, Biology, Yale University, New
            Haven, CT, USA
FEATURES             Location/Qualifiers
     source          1..5028
                     /organism="Saccharomyces cerevisiae"
                     /db_xref="taxon:4932"
                     /chromosome="IX"
                     /map="9"
     CDS             <1..206
                     /codon_start=3
                     /product="TCP1-beta"
                     /protein_id="AAA98665.1"
                     /db_xref="GI:1293614"
                     /translation="SSIYNGISTSGLDLNNGTIADMRQLGIVESYKLKRAVVSSASEA
                     AEVLLRVDNIIRARPRTANRQHM"
     gene            687..3158
                     /gene="AXL2"
     CDS             687..3158
                     /gene="AXL2"
                     /note="plasma membrane glycoprotein"
                     /codon_start=1
                     /function="required for axial budding pattern of S.
                     cerevisiae"
                     /product="Axl2p"
                     /protein_id="AAA98666.1"
                     /db_xref="GI:1293615"
                     /translation="MTQLQISLLLTATISLLHLVVATPYEAYPIGKQYPPVARVNESF
                     TFQISNDTYKSSVDKTAQITYNCFDLPSWLSFDSSSRTFSGEPSSDLLSDANTTLYFN
                     VILEGTDSADSTSLNNTYQFVVTNRPSISLSSDFNLLALLKNYGYTNGKNALKLDPNE
                     VFNVTFDRSMFTNEESIVSYYGRSQLYNAPLPNWLFFDSGELKFTGTAPVINSAIAPE
                     TSYSFVIIATDIEGFSAVEVEFELVIGAHQLTTSIQNSLIINVTDTGNVSYDLPLNYV
                     YLDDDPISSDKLGSINLLDAPDWVALDNATISGSVPDELLGKNSNPANFSVSIYDTYG
                     DVIYFNFEVVSTTDLFAISSLPNINATRGEWFSYYFLPSQFTDYVNTNVSLEFTNSSQ
                     DHDWVKFQSSNLTLAGEVPKNFDKLSLGLKANQGSQSQELYFNIIGMDSKITHSNHSA
                     NATSTRSSHHSTSTSSYTSSTYTAKISSTSAAATSSAPAALPAANKTSSHNKKAVAIA
                     CGVAIPLGVILVALICFLIFWRRRRENPDDENLPHAISGPDLNNPANKPNQENATPLN
                     NPFDDDASSYDDTSIARRLAALNTLKLDNHSATESDISSVDEKRDSLSGMNTYNDQFQ
                     SQSKEELLAKPPVQPPESPFFDPQNRSSSVYMDSEPAVNKSWRYTGNLSPVSDIVRDS
                     YGSQKTVDTEKLFDLEAPEKEKRTSRDVTMSSLDPWNSNISPSPVRKSVTPSPYNVTK
                     HRNRHLQNIQDSQSGKNGITPTTMSTSSSDDFVPVKDGENFCWVHSMEPDRRPSKKRL
                     VDFSNKSNVNVGQVKDIHGRIPEML"
     gene            complement(3300..4037)
                     /gene="REV7"
     CDS             complement(3300..4037)
                     /gene="REV7"
                     /codon_start=1
                     /product="Rev7p"
                     /protein_id="AAA98667.1"
                     /db_xref="GI:1293616"
                     /translation="MNRWVEKWLRVYLKCYINLILFYRNVYPPQSFDYTTYQSFNLPQ
                     FVPINRHPALIDYIEELILDVLSKLTHVYRFSICIINKKNDLCIEKYVLDFSELQHVD
                     KDDQIITETEVFDEFRSSLNSLIMHLEKLPKVNDDTITFEAVINAIELELGHKLDRNR
                     RVDSLEEKAEIERDSNWVKCQEDENLPDNNGFQPPKIKLTSLVGSDVGPLIIHQFSEK
                     LISGDDKILNGVYSQYEEGESIFGSLF"
ORIGIN
        1 gatcctccat atacaacggt atctccacct caggtttaga tctcaacaac ggaaccattg
       61 ccgacatgag acagttaggt atcgtcgaga gttacaagct aaaacgagca gtagtcagct
      121 ctgcatctga agccgctgaa gttctactaa gggtggataa catcatccgt gcaagaccaa
      181 gaaccgccaa tagacaacat atgtaacata tttaggatat acctcgaaaa taataaaccg
      241 ccacactgtc attattataa ttagaaacag aacgcaaaaa ttatccacta tataattcaa
      301 agacgcgaaa aaaaaagaac aacgcgtcat agaacttttg gcaattcgcg tcacaaataa
      361 attttggcaa cttatgtttc ctcttcgagc agtactcgag ccctgtctca agaatgtaat
      421 aatacccatc gtaggtatgg ttaaagatag catctccaca acctcaaagc tccttgccga
      481 gagtcgccct cctttgtcga gtaattttca cttttcatat gagaacttat tttcttattc
      541 tttactctca catcctgtag tgattgacac tgcaacagcc accatcacta gaagaacaga
      601 acaattactt aatagaaaaa ttatatcttc ctcgaaacga tttcctgctt ccaacatcta
      661 cgtatatcaa gaagcattca cttaccatga cacagcttca gatttcatta ttgctgacag
      721 ctactatatc actactccat ctagtagtgg ccacgcccta tgaggcatat cctatcggaa
      781 aacaataccc cccagtggca agagtcaatg aatcgtttac atttcaaatt tccaatgata
      841 cctataaatc gtctgtagac aagacagctc aaataacata caattgcttc gacttaccga
      901 gctggctttc gtttgactct agttctagaa cgttctcagg tgaaccttct tctgacttac
      961 tatctgatgc gaacaccacg ttgtatttca atgtaatact cgagggtacg gactctgccg
     1021 acagcacgtc tttgaacaat acataccaat ttgttgttac aaaccgtcca tccatctcgc
     1081 tatcgtcaga tttcaatcta ttggcgttgt taaaaaacta tggttatact aacggcaaaa
     1141 acgctctgaa actagatcct aatgaagtct tcaacgtgac ttttgaccgt tcaatgttca
     1201 ctaacgaaga atccattgtg tcgtattacg gacgttctca gttgtataat gcgccgttac
     1261 ccaattggct gttcttcgat tctggcgagt tgaagtttac tgggacggca ccggtgataa
     1321 actcggcgat tgctccagaa acaagctaca gttttgtcat catcgctaca gacattgaag
     1381 gattttctgc cgttgaggta gaattcgaat tagtcatcgg ggctcaccag ttaactacct
     1441 ctattcaaaa tagtttgata atcaacgtta ctgacacagg taacgtttca tatgacttac
     1501 ctctaaacta tgtttatctc gatgacgatc ctatttcttc tgataaattg ggttctataa
     1561 acttattgga tgctccagac tgggtggcat tagataatgc taccatttcc gggtctgtcc
     1621 cagatgaatt actcggtaag aactccaatc ctgccaattt ttctgtgtcc atttatgata
     1681 cttatggtga tgtgatttat ttcaacttcg aagttgtctc cacaacggat ttgtttgcca
     1741 ttagttctct tcccaatatt aacgctacaa ggggtgaatg gttctcctac tattttttgc
     1801 cttctcagtt tacagactac gtgaatacaa acgtttcatt agagtttact aattcaagcc
     1861 aagaccatga ctgggtgaaa ttccaatcat ctaatttaac attagctgga gaagtgccca
     1921 agaatttcga caagctttca ttaggtttga aagcgaacca aggttcacaa tctcaagagc
     1981 tatattttaa catcattggc atggattcaa agataactca ctcaaaccac agtgcgaatg
     2041 caacgtccac aagaagttct caccactcca cctcaacaag ttcttacaca tcttctactt
     2101 acactgcaaa aatttcttct acctccgctg ctgctacttc ttctgctcca gcagcgctgc
     2161 cagcagccaa taaaacttca tctcacaata aaaaagcagt agcaattgcg tgcggtgttg
     2221 ctatcccatt aggcgttatc ctagtagctc tcatttgctt cctaatattc tggagacgca
     2281 gaagggaaaa tccagacgat gaaaacttac cgcatgctat tagtggacct gatttgaata
     2341 atcctgcaaa taaaccaaat caagaaaacg ctacaccttt gaacaacccc tttgatgatg
     2401 atgcttcctc gtacgatgat acttcaatag caagaagatt ggctgctttg aacactttga
     2461 aattggataa ccactctgcc actgaatctg atatttccag cgtggatgaa aagagagatt
     2521 ctctatcagg tatgaataca tacaatgatc agttccaatc ccaaagtaaa gaagaattat
     2581 tagcaaaacc cccagtacag cctccagaga gcccgttctt tgacccacag aataggtctt
     2641 cttctgtgta tatggatagt gaaccagcag taaataaatc ctggcgatat actggcaacc
     2701 tgtcaccagt ctctgatatt gtcagagaca gttacggatc acaaaaaact gttgatacag
     2761 aaaaactttt cgatttagaa gcaccagaga aggaaaaacg tacgtcaagg gatgtcacta
     2821 tgtcttcact ggacccttgg aacagcaata ttagcccttc tcccgtaaga aaatcagtaa
     2881 caccatcacc atataacgta acgaagcatc gtaaccgcca cttacaaaat attcaagact
     2941 ctcaaagcgg taaaaacgga atcactccca caacaatgtc aacttcatct tctgacgatt
     3001 ttgttccggt taaagatggt gaaaattttt gctgggtcca tagcatggaa ccagacagaa
     3061 gaccaagtaa gaaaaggtta gtagattttt caaataagag taatgtcaat gttggtcaag
     3121 ttaaggacat tcacggacgc atcccagaaa tgctgtgatt atacgcaacg atattttgct
     3181 taattttatt ttcctgtttt attttttatt agtggtttac agatacccta tattttattt
     3241 agtttttata cttagagaca tttaatttta attccattct tcaaatttca tttttgcact
     3301 taaaacaaag atccaaaaat gctctcgccc tcttcatatt gagaatacac tccattcaaa
     3361 attttgtcgt caccgctgat taatttttca ctaaactgat gaataatcaa aggccccacg
     3421 tcagaaccga ctaaagaagt gagttttatt ttaggaggtt gaaaaccatt attgtctggt
     3481 aaattttcat cttcttgaca tttaacccag tttgaatccc tttcaatttc tgctttttcc
     3541 tccaaactat cgaccctcct gtttctgtcc aacttatgtc ctagttccaa ttcgatcgca
     3601 ttaataactg cttcaaatgt tattgtgtca tcgttgactt taggtaattt ctccaaatgc
     3661 ataatcaaac tatttaagga agatcggaat tcgtcgaaca cttcagtttc cgtaatgatc
     3721 tgatcgtctt tatccacatg ttgtaattca ctaaaatcta aaacgtattt ttcaatgcat
     3781 aaatcgttct ttttattaat aatgcagatg gaaaatctgt aaacgtgcgt taatttagaa
     3841 agaacatcca gtataagttc ttctatatag tcaattaaag caggatgcct attaatggga
     3901 acgaactgcg gcaagttgaa tgactggtaa gtagtgtagt cgaatgactg aggtgggtat
     3961 acatttctat aaaataaaat caaattaatg tagcatttta agtataccct cagccacttc
     4021 tctacccatc tattcataaa gctgacgcaa cgattactat tttttttttc ttcttggatc
     4081 tcagtcgtcg caaaaacgta taccttcttt ttccgacctt ttttttagct ttctggaaaa
     4141 gtttatatta gttaaacagg gtctagtctt agtgtgaaag ctagtggttt cgattgactg
     4201 atattaagaa agtggaaatt aaattagtag tgtagacgta tatgcatatg tatttctcgc
     4261 ctgtttatgt ttctacgtac ttttgattta tagcaagggg aaaagaaata catactattt
     4321 tttggtaaag gtgaaagcat aatgtaaaag ctagaataaa atggacgaaa taaagagagg
     4381 cttagttcat cttttttcca aaaagcaccc aatgataata actaaaatga aaaggatttg
     4441 ccatctgtca gcaacatcag ttgtgtgagc aataataaaa tcatcacctc cgttgccttt
     4501 agcgcgtttg tcgtttgtat cttccgtaat tttagtctta tcaatgggaa tcataaattt
     4561 tccaatgaat tagcaatttc gtccaattct ttttgagctt cttcatattt gctttggaat
     4621 tcttcgcact tcttttccca ttcatctctt tcttcttcca aagcaacgat ccttctaccc
     4681 atttgctcag agttcaaatc ggcctctttc agtttatcca ttgcttcctt cagtttggct
     4741 tcactgtctt ctagctgttg ttctagatcc tggtttttct tggtgtagtt ctcattatta
     4801 gatctcaagt tattggagtc ttcagccaat tgctttgtat cagacaattg actctctaac
     4861 ttctccactt cactgtcgag ttgctcgttt ttagcggaca aagatttaat ctcgttttct
     4921 ttttcagtgt tagattgctc taattctttg agctgttctc tcagctcctc atatttttct
     4981 tgccatgact cagattctaa ttttaagcta ttcaatttct ctttgatc
//
_END_

# Main Window
my $mw = new MainWindow;
$mw->geometry("1000x600");
$mw->resizable(0, 0); # do not allow window to be resized
$mw->title("BIF724 Project....");

# add help menu (with 2 options) to window
my $appDesc = " This application has four main functions: \n\n
The first function is DISPLAY which will download and 
display the genbank file corresponding to the given
accession number.\n\n
The second function is PWSA which will perform a pair wise
sequence alignment with the supplied sequence in the
Sequence field. The output will be displayed in the text area
screen.\n\n
The third function is CLEAVE which will cleave the entire genbank
nucleotide genome (spliced using the string supplied in the sequence
field) and display the output. Each string will appear on a separate line
with length markers along the top in increments of 60.\n\n
The fourth function BASESTATS will return the number of A, C, T, G 
present in the genbank sequence";
$mw->configure(-menu => my $menubar = $mw->Menu);
my $help = $menubar->cascade(-label => 'Help');
$help->command(-label=>'Version',
               -command=>sub { $mw->Dialog(-title=>'Project Version...', -text =>'Version 1.0',
                                           -default_button=>'OK')->Show( ); });
$help->command(-label=>'About',
               -command=>sub { $mw->Dialog(-title=>'About...', -text =>$appDesc,
                                           -default_button=>'OK')->Show( ); });

# main window widgets
my $accTitle  = $mw->Label(-text=>"Enter NCBI accession number...")->place(-x=>80, -y=>5);
my $accLabel  = $mw->Label(-text=>"Accession:")->place(-x=>10, -y=>25);
my $accEntry  = $mw->Entry( )->place(-x=>80, -y=>25);
my $query     = $mw->Label(-text=>"Query Subrange...")->place(-x=>300, -y=>5);
my $fromLabel = $mw->Label(-text=>"From:")->place(-x=>300, -y=>25);
my $fromEntry = $mw->Entry( )->place(-x=>340, -y=>25);
my $toLabel   = $mw->Label(-text=>"To:")->place(-x=>300, -y=>50);
my $toEntry   = $mw->Entry( )->place(-x=>340, -y=>50);

my $resTitle  = $mw->Label(-text=>"Enter sequence...")->place(-x=>80, -y=>70);
my $resLabel  = $mw->Label(-text=>"Sequence:")->place(-x=>10, -y=>90);

my $seqData="";
my $seqFile="";
my $email="";

my $resEntry  = $mw->Entry(-width=>80, -textvariable=>\$seqData)->place(-x=>80, -y=>90);

my $browseButton = $mw->Button(-text => 'Browse...',
                               -command => sub { # inline subroutine to read file data
                                                 $seqFile = $mw->getOpenFile( );
                                                 print "seqFile: $seqFile\n";
                                                 $/ = undef;
                                                 open(FD, "< $seqFile");
                                                 $seqData = <FD>;
                                                 $/ = "\n";
                                                 close(FD);
                                               }
                               )->place(-x=>600, -y=>85);

my $seqType = "";
my @options = qw/DISPLAY PWSA CLEAVE BASESTATS/;

my $jobLabel  = $mw->Label(-text=>"Function:")->place(-x=>10, -y=>130);

my $menu = $mw->Optionmenu(
    -variable => \$seqType,
    -options  => [@options],
    -command  => [sub {print "args=$seqType\n"}]
    )->place(-x=>80, -y=>130);

# for debug purposes
print "seqType is: $seqType\n";

my $emailLabel  = $mw->Label(-text=>"Email:")->place(-x=>400, -y=>130);
my $emailEntry  = $mw->Entry(-width=>50, -textvariable=>\$email)->place(-x=>450, -y=>130);

# main output window configured as a scrollable window attached to a new frame
my $textArea = $mw->Frame(-width=>100, -height=>50, -borderwidth=>1, -relief=>'groove')->place(-x=>80,-y=>190);
my $output = $textArea->Scrolled('ROText', -scrollbars=>'se', -height=>25,
                                 -width=>80, -wrap=>'none')->pack(-side=>'left',
                                                                  -pady=>'5',
                                                                  -padx=>'5');
$output->configure(-background => "GREY");
$output->insert('end', "$sampleGenbank");

my $processButton = $mw->Button(-text=>"Process", -command=>\&button1Sub)->place(-x=>700, -y=>190);
my $exitButton    = $mw->Button(-text=>"Exit",    -command=>\&button2Sub)->place(-x=>700, -y=>220);

sub button1Sub {
   $mw->messageBox(-message=>"Processing...", -type=>"OK");
   my ($genBankEntry, $genBankURL, $fastaURL, $genBankData, $result, $valid);
   
   #Retrieves accession number, start query range and end query range
   my $accNum = $accEntry->get();
   my $startIndex = $fromEntry->get(); 
   my $endIndex = $toEntry->get();
   
   $genBankURL = "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nucleotide&id=$accNum&rettype=gb";
   $fastaURL = "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nucleotide&id=$accNum&rettype=fasta";
	
   #Uses BIOPERL to retrieve the sequence
   $genBankEntry = get($genBankURL);

   #If the accession number is valid the URL will be defined, however if it is not valid the URL will not be defined.
   #If the accession number is defined then the appropriate action will be taken based on the desired user input   
   if (defined $genBankEntry){
      my $db_obj = Bio::DB::GenBank-> new;
      my $seq = $db_obj->get_Seq_by_acc($accNum);
      my $seq_obj = $seq->seq;
      #If DISPLAY is chosen the entire file will be printed to the screen
      if($seqType eq "DISPLAY"){
	     $output->delete('0.0', 'end');
	     $output->insert('end', "$genBankEntry");
		 sendMail($email, $genBankEntry);
	  }
	  #If CLEAVE is chosen the fragments and length markers are displayed to the screen
	  elsif($seqType eq "CLEAVE"){	
	     #Checks to see if the query range entered is valid and takes the appropriate action
	     $valid = isSubRangeValid($startIndex, $endIndex, $seq_obj);
		 $seqData = uc($seqData);
         if($valid == 1){
            $seq_obj = substr($seq_obj, $startIndex-1, $endIndex-1);		 
		    $result = CLEAVE($seq_obj, $seqData);
	        $output->delete('0.0', 'end');
	        $output->insert('end', $result);
		    sendMail($email, $result);
		 }
		 elsif($valid == 2){
		    $result = CLEAVE($seq_obj, $seqData);
	        $output->delete('0.0', 'end');
	        $output->insert('end', $result);
		    sendMail($email, $result); 
		 }
         else{
		    $mw->messageBox(-message=>"Invalid Query Range!! Please double check the values entered!", -type=>"OK");   
		 }		 
	  }
	  #If PWSA is chosen the alignment is completed and the result is printed to the screen
	  elsif($seqType eq "PWSA"){
	     $seqData = uc($seqData);
	     $valid = isSubRangeValid($startIndex, $endIndex, $seq_obj);
         if($valid == 1){	
		    $seq_obj = substr($seq_obj, $startIndex-1, $endIndex-1);	
		    $result = PWSA($seq_obj, $seqData);
		    $output->delete('0.0', 'end');
		    $output->insert('end', $result);
		    sendMail($email, $result);
		 }
		 elsif($valid == 2){
		    $result = PWSA($seq_obj, $seqData);
		    $output->delete('0.0', 'end');
		    $output->insert('end', $result);
		    sendMail($email, $result);
		 }
         else{
		    $mw->messageBox(-message=>"Invalid Query Range!! Please double check the values entered!", -type=>"OK");  
		 }		 
	  }
	  #If BASESTATS is chosen the number of bases in the genbank sequence are printed to the screen
	  elsif($seqType eq "BASESTATS"){
	     $valid = isSubRangeValid($startIndex, $endIndex, $seq_obj);
		 print($valid);
         if($valid == 1){	
		    $seq_obj = substr($seq_obj, $startIndex-1, $endIndex-1);	
		    $result = BASESTATS($seq_obj);
		    $output->delete('0.0', 'end');
		    $output->insert('end', $result);
		    sendMail($email, $result);
		 }
		 elsif($valid == 2){
		    $result = BASESTATS($seq_obj);
		    $output->delete('0.0', 'end');
		    $output->insert('end', $result);
		    sendMail($email, $result);
		 }	
         else{
		    $mw->messageBox(-message=>"Invalid Query Range!! Please double check the values entered!", -type=>"OK");  
		 }			 
	  }
   }
   else {
      $mw->messageBox(-message=>"Invalid Accession Number!! Please double check the values entered!", -type=>"OK");
   }
   
}
sub button2Sub {
   my $dialog = $mw->DialogBox(-title => 'Are you sure?', -buttons => ['Exit', 'Cancel'],
                     -default_button => 'Exit');
   my $answer = $dialog->Show( );
   if($answer eq "Exit") {
      exit;
   }
}

#sub isSequenceValid($){
#  my $userSeq = shift(@_);
#}

sub isSubRangeValid($$$){
   my $startNum = shift(@_);
   my $endNum = shift(@_);
   my $genSeq = shift(@_);
   #Checks to see if anything was entered in the query sub range. 
   if(($startNum ne "" && $endNum ne "")){
      #Checks to see if a number was entered
	  if(($startNum =~ /[0-9]/)&&($endNum =~/[0-9]/)) {
         #Makes sure that the numbers are within the index range of the sequence
		 if((($startNum >= 1) && ($startNum <= length($genSeq))) && (($endNum >= 1) && ($endNum <= length($genSeq)))){
            #Returns 1 if the query range is valid
			return(1);
         }
         else{
		    #If the query range is not valid 0 is returned
            return(0);
		 }
      }    		 
   }
   else{ 
      return(2);
   }	   
 }  

sub PWSA($$){
   #Uses the Needleman and Wunsch algorithm
   my $sequence1 = shift(@_);
   my $sequence2 = shift(@_);
   $sequence1 =~ s/[\s\d]//g;	
   $sequence2 =~ s/[\s\d]//g;	
   
   #Scoring matrix
   my $match = 1;
   my $misMatch = -1;
   my $gapPenalty = -1;
   
   my($diagScore, $leftScore, $upScore) = 0;
   my @scoreMatrix;
   my @alignmentMatrix;
   my $alignedSequence;
   
   #Initialize matrices 
   $scoreMatrix[0][0] = 0;
   $alignmentMatrix[0][0] = "none";
   for (my $x = 1; $x <= length($sequence1); $x++){
      $scoreMatrix[0][$x] = $gapPenalty * $x;
	  $alignmentMatrix[0][$x] = "left";
   }
   for (my $y = 1; $y <= length($sequence2); $y++){
      $scoreMatrix[$y][0] = $gapPenalty * $y;
	  $alignmentMatrix[$y][0] = "up";
   }
   
   #Fill up matrices with scores
   for (my $y = 1; $y <= length($sequence2); $y++){
      for (my $x = 1; $x <= length($sequence1); $x++){
		 
		 if(substr($sequence1, $x-1, 1) eq substr($sequence2, $y-1, 1)){
		    $diagScore = $scoreMatrix[$y-1][$x-1] + $match;
		 }
		 else{
		    $diagScore = $scoreMatrix[$y-1][$x-1] + $misMatch;
		 }
		 
		 #Calculating gap scores
		 $upScore = $scoreMatrix[$y-1][$x] + $gapPenalty;
		 $leftScore = $scoreMatrix[$y][$x-1] + $gapPenalty;
		 
		 #Determines the best score
		 if(($diagScore >= $upScore) && ($diagScore >= $leftScore)){
		    $scoreMatrix[$y][$x] = $diagScore;
			$alignmentMatrix[$y][$x] = "diagonal";
		 }
		 elsif(($leftScore >= $upScore) && ($leftScore >= $diagScore)){
		    $scoreMatrix[$y][$x] = $leftScore;
			$alignmentMatrix[$y][$x] = "left";
		 }
         else{
		    $scoreMatrix[$y][$x] = $upScore;
			$alignmentMatrix[$y][$x] = "up";
		 }		 
	  }
   }
   
   #Traceback step to determine the alignment
   my $alignedSequence1 = "";
   my $alignedSequence2 = "";
   
   #Begin traceback at the last cell of the scoreMatrix
   my $x = length($sequence1);
   my $y = length($sequence2);
  
   while($alignmentMatrix[$y][$x] ne "none") {
      if($alignmentMatrix[$y][$x] eq "diagonal"){
	     $alignedSequence1.= substr($sequence1, $x-1, 1);
		 $alignedSequence2.= substr($sequence2, $y-1, 1);
		 $x--;
		 $y--;
	  }
	  elsif ($alignmentMatrix[$y][$x] eq "left"){
	     $alignedSequence1.= substr($sequence1, $x-1, 1);
		 $alignedSequence2.= "-";
		 $x--;
	  }
	  elsif ($alignmentMatrix[$y][$x] eq "up"){
	     $alignedSequence1.= "-";
		 $alignedSequence2.= substr($sequence2, $y-1, 1);
		 $y--;
	  }
   }
   #Reverse sequences
   $alignedSequence1 = reverse $alignedSequence1;
   $alignedSequence2 = reverse $alignedSequence2;
   #Generate output string
   $alignedSequence = "Sequence1>$alignedSequence1\nSequence2>$alignedSequence2";
   return($alignedSequence);
   
}

sub CLEAVE($$){
   #Initialize variables
   my $genSeq = shift(@_);
   my $userInput = shift(@_);
   my $splitSequence;
   
   #Split genbank sequence based on the user input sequence
   my @cleavedSequences = split(/(.*?$userInput)/, $genSeq);
   my ($sequenceCounter, $cleaveResult);
   
   #Foreach fragment created generate a length marker then add the sequence once the markers have been created
   #Repeat for each fragment until final output string is created   
   foreach $splitSequence (@cleavedSequences){
      for(my $i = 1; $i <= length($splitSequence); $i++){
	     if($i%60==0){
		    $cleaveResult.= $i;
			$i = $i + length($i)
		 }
		 else{
		    $cleaveResult.= " ";
		 }
	  }
	  $cleaveResult.="\n";
	  $cleaveResult.="$splitSequence\n";
   }
   return($cleaveResult);
   
}

sub BASESTATS($){
  #Initialize variable
   my $inputSeq = shift(@_); 
   my ($acount, $ccount, $tcount, $gcount) = 0;
   for (my  $i=0; $i<=length($inputSeq); $i++) {			#Loops through the sequence and checks each value and counts the number of a, c, t, g that are found
      if((substr($inputSeq, $i, 1) eq 'a')||(substr($inputSeq, $i, 1) eq 'A')){
         $acount++;
      }
      elsif((substr($inputSeq, $i, 1) eq 'c')||(substr($inputSeq, $i, 1) eq 'C')){
         $ccount++;
      }
      elsif((substr($inputSeq, $i, 1) eq 't')||(substr($inputSeq, $i, 1) eq 'T')){
         $tcount++;
      }
      elsif((substr($inputSeq, $i, 1) eq 'g')||(substr($inputSeq, $i, 1) eq 'G')){
         $gcount++;
      }
   }
   my $baseStats = ("Base Count: A:  $acount C:  $ccount T:  $tcount G: $gcount \n ");		#Returns the values found 
   return ($baseStats);
}

sub sendMail($$){
   my $userEmail = shift(@_);
   my $results = shift(@_);

   #Creates the email to be sent
   my $email = Email::Simple->create(
      header => [
                        From    => 'thilukshanbif724@gmail.com',
                        To      => $userEmail,
                        Subject => 'BIF724 GUI Results',
                       ],
                      body => $results,
   );

   #Email information that will send the desired email
   my $sender = Email::Send->new(
       {   
	      mailer      => 'Gmail',
          mailer_args => [
          username => 'thilukshanbif724@gmail.com',
          password => "bioinformatics",
          ]
      }
   );
   #Makes sure that email is a valid email and if it is the result is sent.
   if($userEmail=~ m/[a-zA-Z0-9\-\.]{2,}\@[a-zA-Z0-9\-\.]{2,}\.[a-zA-Z]{2,4}/){
      eval { $sender->send($email) };
	  die "Error sending email: $@" if $@;
   }
}

MainLoop;
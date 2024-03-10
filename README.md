# Hill Cipher breaker

Yon Ploj, 63200025

## Delovanje

Program zlomi Hillovo sifro. Vhod je datoteka z imenom cipher.txt, ki vsebuje sifrirano sporocilo.

Program po vrsti poskuša vse N, ki delijo dolžino sporočila.

1. Vsak vektor iz Z_{26}^N skalarno množi z N-terkami crk iz šifre. Rezultatom s frekvenčno analizo izračuna chi2 razdaljo od porazdelitve frekvenc crk v angleškem jeziku. Najboljših N N-terk shrani.
2. Vse shranjene N-terke permutira kot vrstice matrike, s katero dešifrira celotno šifro.
3. Vsako tako dekodirano besedilo je prikazano uporabniku, da lahko izbere pravo.
4. Ko dobimo pravo besedilo, program ustavimo s kombinacijo tipk Ctrl-C.

## Uporaba
```ocaml
$ ocaml main.ml
cipher_len = 604
Keylens that divide cipher_len: 1 2 4 151 302 604 
Finding best 1 of 26 keys
Trying 1 different keys for keylen = 1
1.
xctystngbaohxpaitrhoehqmoddrqaoewazewflcxipeoyfyroyyoossjiehoncrlpaidnehccrnfeysronotiofwrdaaijnkrwmsrvahaulxsdateeojppadeltrowswnteehtowitidatononadexctyatsdmeusagzauimechsrpdehodccqdqnatfcenwqdeseodpdtoeevofevtkeurcganwljntowmctroroelowvttiatvnlesrmcmpdeutybhbehsrqbxpeeclqdqnpukwdnlekpmrrowsivjfkogdtibgehusymvteecrlpuoqrfpryjifedarukexfdeyumezauiqeoftrehwsvnfeyblboftrehtiatvnlesrmcmpdeytvnheseramebdfokpzrtovtqeddfeuscrysonteehodivmlopdestjfhotomcfpfewmfctimetiewprkdpagivnvtqedddestifkospatmrtiewprkdpakivtwetewhidyulesticfrmyfuxctystmlkgchivgbccymtixcqeysqnelccxmuloxvnjiusjpwlicctroqmsrowodvssrva
===
Press enter to continue ...

Keys of length 1 exhausted
Keylens that divide cipher_len: 2 4 151 302 604 
Finding best 2 of 676 keys
600 keys left ...
500 keys left ...
400 keys left ...
300 keys left ...
200 keys left ...
100 keys left ...
Trying 2 different keys for keylen = 2
15.18.
0.1.
rcpyotrgpayhrpoitrtoehomednrgawesafeeftcvilesynynomyuowstiehcnyrtpoitnehocvnreisnofoniofmrtaoifnoramerdabaeltstateaoppranentnoessnteehroginitarofonanercpyetmdseaseglaciseahertdehedocidgnethcinuqneeeedtdrocevorehtoeiriganilfnroamitnonoyliwhtnietdndeericipnestobtbeherybrpceulidgnnuawtndeepsrnoesevrfmoodnitgehasemhtceyrtpgoarhplytiretaruoetfnesuselaciaeoftrehesdnreobbboftrehnietdndeericipneatdnveeevaserdpoepfrrohtaevdreasyriscnteehedevolmpneotrftoroichpreamhcniseniowlrwdraaidnhtaevdneotcfmoupetsrniowlrwdraiihtmeteohsdsudeotacrroyturcpyotolygahevebocemnircaeisgnylocpmelaxdntiasppilacitnoomeriwedpserda
===
Press enter to continue ...

0.1.
15.18.
cryptographypriortothemodernagewaseffectivelysynonymouswithencryptiontheconversionofinformationfromareadablestatetoapparentnonsensetheoriginatorofanencryptedmessagealicesharedthedecodingtechniqueneededtorecovertheoriginalinformationonlywithintendedrecipientsbobtherebyprecludingunwantedpersonsevefromdoingthesamethecryptographyliteratureoftenusesaliceaforthesenderbobbfortheintendedrecipientandeveeavesdropperfortheadversarysincethedevelopmentofrotorciphermachinesinworldwariandtheadventofcomputersinworldwariithemethodsusedtocarryoutcryptologyhavebecomeincreasinglycomplexanditsapplicationmorewidespread
===
Press enter to continue ...
^C
```

Dešifriranemu sporočilu je potrebno ročno dodati presledke in ločila.

Rezultat primera je torej:
```
Cryptography prior to the modern age was effectively synonymous with encryption, the conversion of information from a readable state to apparent nonsense. The originator of an encrypted message alice shared the decoding technique needed to recover the original information only with intended recipients bob thereby precluding unwanted persons eve from doing the same. The cryptography literature often uses alice a for the sender, bob b for the intended recipient, and eve e avesdropper for the adversary. Since the development of rotor cipher machines in world war i and the advent of computers in world war ii, the methods used to carry out cryptology have become increasingly complex and its application more widespread.
```

Za dekripcijo večjega ključa potrebujemo več časa. Za primer sem vzel skritpo filma Bee Movie in 4x4 kljuc. S priblizno 

TODO

 iteracijami/s je program zakljucil iskanje v 
 
 TODO
 
  minutah. Čas bi lahko trivialno skrajšali, če bi iskanje kljucev paralelizirali z več procesi / z grafično kartico.

Dodaten problem pri 4x4 ključu je bilo veliko število premutacij končne matrike. Proces bi pospešili, če bi v besedilu iskali besede s slovarjem. Permutacija z največjim pokritjem slovarskih besed bi bila izbrana za pravilno.

# Hill Cipher breaker

Yon Ploj, 63200025

## Delovanje
Program zlomi Hillovo sifro. Vhod je datoteka z imenom `cipher.txt`, ki vsebuje sifrirano sporocilo.

Program po vrsti poskusa vse N, ki delijo dolzino sporocila.
1. Vsak vektor iz Z_{26}^N skalarno mnozi z N-terkami crk iz sifre. Rezultatom s frekvencno analizo izracuna chi2 razdaljo od porazdelitve frekvenc crk v angleskem jeziku. Najboljsih N N-terk shrani.
2. Vse shranjene N-terke permutira kot vrstice matrike, s katero desifrira celotno sifro.
3. Vsako tako dekodirano besedilo je prikazano uporabniku, da lahko izbere pravo.
4. Ko dobimo pravo besedilo, program ustavimo s Ctrl-C.

## Različice
* [Python (2023)](https://github.com/plojyon/hill_breaker/tree/python)
* [OCaml (2024)](https://github.com/plojyon/hill_breaker/tree/ocaml)

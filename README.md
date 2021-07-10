# Debugging in Purescript

Jak tento projekt spustit:

1. Stáhněte zip a otevřete rozbalenou složku ve VSCode
2. `spago build`
3. `spago repl`
4. V `src/Main.hs` je demonstrace knihovny [Debug](https://pursuit.purescript.org/packages/purescript-debug/5.0.0/docs/Debug).


V REPLu si můžete hrát s dvěma funkcemi, `main` a `concatAndMeasure`. Funkce `concatAndMeasure` demonstruje funkci `spy` z [Debug](https://pursuit.purescript.org/packages/purescript-debug/5.0.0/docs/Debug), která slouží k printování hodnot s custom popiskem.

```
> import Main
> concatAndMeasure "A" "B"
a bylo: 'A'
b bylo: 'B'
2
```

Funkce `main` pak demostruje `traceM`, který se chová skoro jako `(log <<< show)` ale funguje v jakékoli monádě, zatímco `log` funguje jen v `Effektu`. Více o `Effect` níže.

## Jak debugovat ve svém projektu

1. Přidejte balík [Debug](https://pursuit.purescript.org/packages/purescript-debug/5.0.0/docs/Debug) pomocí `spago install debug`
2. `spago build`
3. `import Debug`

Nejčastěji asi budete používat funkci

```hs
spy :: forall a. DebugWarning => String -> a -> a
```

Která printuje hodnotu `a` s komentářem, který jí dáte (a pak tu hodnotu i vrátí). Tam, kde předtím bylo jen `x` dáte `(spy "popisek" x)` a vše by mělo fungovat.

Typová třída `DebugWarning` je vlastně jen interní a slouží k vyvolání speciální warningu — který vás varuje, abyste `spy` nenechali v production kódu. Kdybyste měli problémy, například s typy, napište mi.


## (Bonus) Proč to děláme takhle?

Proč má Purescript dva druhy printů, nebo vlastně ještě více; `log :: String -> Effect Unit`, `traceM :: Monad m => String -> m Unit`, atd?

V Purescriptu se funkce honosí tím, že se můžete na 100% spolehnout, že když jim opakovaně budete dávat stejné vstupy, ony budou vracet stejné výstupy, **nezávisle na okolních podmínkách**. To je výhodné, protože se s těmito funkcemi velice dobře pracuje; je to velká záruka spolehlivosti a toho, že se vám nic záhadně nerozbije.

Jak tuto záruku bezpečnosti ale zařídit u funkcí, které _závisí_ na okolních podmínkách, například čtou soubory nebo vypisují do konzole?

Řešením je výstup těchto funkcí označit nálepkou, která bude říkat, že ta vytvořená (třeba ze souboru načtená) hodnota je "špinavá"; tahle nálepka je v Purescriptu obstarána typem `Effect`. Jakmile vidíte `Effect a`, jedná se o nějaké `a`, které bylo vytvořeno při interagování s vnějším messy světem.

Neexistuje žádný způsob, jak se této nálepky `Effect` zbavit, a zároveň všechny funkce interagující s vnějším světem vrací nějaký `Effect`. Navíc jakmile nějaká funkce interaguje se světem, musí vrátit `Effect` a protože se té nálepky by design nejde zbavit, i funkce nad ní musí vracet `Effect`, a pak zase funkce nad ní a tak dále až do `main`u. Nakonec tedy podle typu umíme poznat, které funkce jsou "bezpečné" (bez `Effect`) a které ne.

Zbývá ale poslední potíž: co když chcete jen dočasně něco vyprintovat do konzole v rámci debuggingu? Musíte dočasně přepsat typy všech debuggovaných funkcí, aby vracely `Effect`? Nebo budete v `Effect` preventivně psát všechny funkce už od začátku, čímž ale přijdete o tu informaci, co je bezpečné a co ne, protože se všechno tváří nebezpečně? (to druhé mimochodem vlastně funguje v C-like jazycích)

Řešeí to právě knihovna `Debug`, která nálepku `Effekt` zcela obchází; slouží ale opravdu jen pro testovací a vývojové účely.
# Statistici App

Quest'app serve a gestire i giocatori del gioco di carte "Statistici".

## Come funziona il gioco di carte "Statistici"

Il gioco di carte "Statistici" è un gioco di carte che si gioca con un mazzo di carte francesi. Il valore delle carte segue la scala 2-Asso e seme cuori-quadri-fiori-picche.

Ogni giocatore riceve 4 carte per il primo gioco, poi 3, poi 2 e infine 1 per poi ricominciare.
Ogni giocatore ha un numero di vite, inizialmente 4, e ogni volta che perde una mano ne perde una.
Vince l'ultimo giocatore rimasto in vita.
Ogni mano è composta da due fasi:

- la prima fase è la fase di dichiarazione, in cui ogni giocatore dichiara il numero di carte che pensa di prendere;
- la seconda fase è la fase di gioco, in cui ogni giocatore in senso antiorario gioca una carta.

Nella fase di dichiarazione, il mazziere non potrà dichiarare un numero di carte che faccia sì che la somma delle dichiarazioni sia uguale al numero di mani.
Nel gioco da una carta, chi prende la mano e aveva dichiarato che l'avrebbe presa, guadagna una vita, rubandola a chi invece pensava di prenderla.

## Come funziona l'app

L'app è composta da tre pagine:

- La pagina principale con la cronologia delle partite;
- La pagina di gestione dei giocatori salvati;
- La pagina di gestione della partita.

### Pagina principale

La pagina principale è composta da una lista di partite, ognuna delle quali ha la data e il vincitore.
Dalla pagina principale è possibile accedere alla lista di giocatori salvati o creare una nuova partita.

### Pagina di gestione dei giocatori salvati

La pagina di gestione dei giocatori salvati è composta da una lista di giocatori, ognuno dei quali ha un nome e un pulsante per eliminarlo.
Inoltre, è presente un pulsante per tornare alla pagina iniziale e uno per creare nuovo giocatore.

### Pagina di gestione della partita

La pagina di gestione della partita è composta da una lista di giocatori, ognuno dei quali ha un nome, delle vite e un pulsante per aggiungerle o rimuoverle.
Inoltre, è presente un pulsante per annullare l'ultima azione, uno per aggiungere un giocatore e uno per tornare alla pagina iniziale.

#### TODO

- [ ] Organizzazione pagine;
- [ ] Aggiunta emoji, frasi e easteregg;
- [ ] Implementazione funzionalità annullo azione;
- [ ] Implementazione funzionalità salva giocatore;

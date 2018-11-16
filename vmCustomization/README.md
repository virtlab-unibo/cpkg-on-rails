How to create the virtual lab client from clean debian stretch
=============

  * Architecture amd 64 debian stretch
  * when installimg debian do not choose desktop

0- scompattare l'archivio compresso nella macchina virtuale nativa, tutte le operazioni successive sono da eseguire come root
1- installare il software di base che si ritiene indispensabile per la nuova macchina virtuale
2- personalizzare il file sources.list nella directory che contiene questo README con gli url dei repository che si vuole aggiungere alla macchina virtuale 
3- nel caso occorra, copiare e decommentare nello script la riga che aggiunge la chiave pubblica per i repository aggiunti 
4- eseguire con i permessi di root lo script vmCustomizer.sh che installa i pacchetti necessari e personalizza alcune configurazioni nella macchina virtuale, al termine spegnere e non riavviare la machina in modo da lasciarla nello stato attuale pronta per l'esportazione
5- esportare da virtualbox la macchina virtuale in formato ova (file->esporta applicazione virtuale)
6- la macchina virtuale al primo avvio eseguirà, come primo servizio, lo script di personalizzazione degli utenti, password, area geografica, mappa tastiera e fuso orario

SONO ALLEGATE AGLI SCRIPT DUE IMMAGINI DI MACCHINE VIRTUALI OVA NATIVE DEBIAN Stretch APPENA INSTALLATE DA IMPORTARE IN VIRTUALBOX PER POI CARICARVI DENTRO IL TAR

PER IL REPO DI VIRTLAB VA INSERITO IN SOURCES.LIST PRIMA DI LANCIARE GLI SCRIPT DI PERSONALIZZAZIONE DELLA MACCHINA VIRTUALE NATIVA/VANILLA

# First version: Michele Cucchi  Ottobre-2016 (michele.cucchi223@gmail.com)

const fs = require('fs');

var firebase = require("firebase/app");
require("firebase/firestore");

var isFirebaseSet = true; // firebase kayıt edilsin mi

var firebaseConfig = {
    apiKey: "AIzaSyC49f1wKiASLR6hD1OKsWSnTOQObkKQd-4",
    authDomain: "postakodubul.firebaseapp.com",
    databaseURL: "https://postakodubul.firebaseio.com",
    projectId: "postakodubul",
    storageBucket: "postakodubul.appspot.com",
    messagingSenderId: "588046437651",
    appId: "1:588046437651:web:453b50f975e11dc7919ee6"
};
// Initialize Firebase
firebase.initializeApp(firebaseConfig);

var data;
var sehirler = [];
var ilceler = [];
var mahalleler = [];

// Firebase 'e kaydetme
async function sehirEkle(sehir) {
    if (isFirebaseSet) {
        return await firebase.firestore().collection('sehirler').add({
            'sehir': sehir
        }).then((s) => {
            return s.id;
        });
    } else {
        return 1;
    }
}

async function ilceEkle(ilce, sehirKey) {
    if (isFirebaseSet) {
        return await firebase.firestore().collection('ilceler').add({
            'sehirKey': sehirKey,
            'ilce': ilce
        }).then((ilce) => {
            return ilce.id;
        });
    } else {
        return 1;
    }
}

async function mahalleEkle(mahalle, ilceKey, postaKodu) {
    if (isFirebaseSet) {
        return await firebase.firestore().collection('mahalleler').add({
            'ilceKey': ilceKey,
            'mahalle': mahalle,
            'postaKodu': postaKodu,
        }).then(() => {
            return null;
        });
    } else {
        return 1;
    }
}

// Dosya Okuma
fs.readFile('tumdata.json', 'utf8', async function (err, fileData) {
    if (err) throw err;
    data = JSON.parse(fileData);
    data = data['Sheet1'];

    for (const key in data) {
        if (data.hasOwnProperty(key)) {
            const sehir = data[key]['il'].trim();
            const ilce = data[key]['ilçe'].trim();
            const mahalle = data[key]['Mahalle'].trim();
            const postaKodu = data[key]['PK'].trim();

            // yeni sehirler listesi
            let sehirKey = isFirebaseSet ? null : 1;
            if (sehirler.includes(sehir) == false) {
                sehirler.push(sehir);
                console.log('sehir ekle');
                sehirKey = await sehirEkle(sehir);
                console.log('sehir eklendi', sehirKey);
            }

            // yeni ilceler listesi
            var found = false;
            for (var i = 0; i < ilceler.length; i++) {
                if (ilceler[i].ilce == ilce && ilceler[i].parent == sehir) {
                    found = true;
                    break;
                }
            }
            let ilceKey = isFirebaseSet ? null : 1;
            if (!found && sehirKey) {
                ilceler.push({
                    'parent': sehir,
                    'ilce': ilce
                });
                console.log('   ilce ekle');
                ilceKey = await ilceEkle(ilce, sehirKey);
                console.log('   ilce eklendi', ilceKey);
            }

            if (ilceKey) {
                mahalleler.push({
                    'mahalle': mahalle,
                    'postaKodu': postaKodu
                });
                console.log('       mahalle ekle');
                await mahalleEkle(mahalle, ilceKey, postaKodu);
                console.log('       mahalle eklendi');
            }

        }
    }

    // Dosyaları Oluştur ////////////////////////
    // sehirler dosyası
    fs.writeFile("data/sehirler.json", JSON.stringify(sehirler), 'utf8', () => {
        console.log('Sehirler dosyası oluştu: data/sehirler.json');
    });
    // ilceler dosyası
    fs.writeFile("data/ilceler.json", JSON.stringify(ilceler), 'utf8', () => {
        console.log('Ilceler dosyası oluştu: data/ilceler.json');
    });
    // mahalleler dosyası
    fs.writeFile("data/mahalleler.json", JSON.stringify(mahalleler), 'utf8', () => {
        console.log('Mahalleler dosyası oluştu: data/mahalleler.json');
    });

});
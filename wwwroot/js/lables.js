
var languagearray;
var languageLoadedPromise = new Promise(resolve => {
    window.resolveLanguageLoaded = resolve;
});

var indexlabel = {
    'hometitle': 0,
    'hometitlefooter': 0,
    'homeLink': 1,
    'privacyLink': 2,
    'sign-in-label': 3,
    'sign-up-label': 4,
    'username-login': 11,
    'password-login': 6,
    'keep-signed-in': 7,
    'forgot-password-link': 9,
    'username-signup': 11,
    'password-signup': 6,
    'repeat-password-signup': 8,
    'already-member-label': 10,
    'singup-message-error': 14,
    'privacytitle': 13,
    'beta-version': 12,

    'My-Portal': 24,
    'Profile': 25,
    'Dashboard': 26,
    'My-Properties': 27,
    'Payments': 28,
    'Maintenance': 29,
    'Settings': 30,
    'Logout': 31,
    
    'FirstNamelabel': 33,
    'SecondNamelabel' : 34,
    'FathersNamelabel' : 35,
    'MothersNamelabel' : 36,
    'Phonelabel' : 37,
    'Emaillabel' : 11,
    'profileh1': 25,

    'TaxDatah2': 44,

    'Changepasswordlabel': 39,
    'OldPassworlabel': 40,
    'Password1label': 41,
    'Password2label': 42,

    'FirstNameerror': 46,
    'SecondNameerror': 47,
    'FathersNameerror': 48,
    'MothersNameerror':49,
    'Emailerror': 50,
    'Phoneerror':51,
    'Passworderror': 53,
    'Password1error': 53,
    'Password2error': 53,
    
    'Titlelabel': 58,
    'Descriptionlabel': 59,
    'Addresslabel': 60,
    'Citylabel': 61,
    'Statelabel': 62,
    'ZipCodelabel': 63,
    'Pricelabel': 64,
    'PropertyTypelabel': 65,
    'AREAlabel': 66,
    'Statuslabel': 67,
    'RentPricelabel': 68,
    'SalePricelabel': 69,
    'Imageurllabel': 70,
    'properties-title': 71,
    'PropertyType-1': 72,
    'PropertyType-2': 73,
    'PropertyType-3': 74,
    'PropertyType-4': 75,
    'STATUS-1': 76,
    'STATUS-2': 77,
    'STATUS-3': 78,
    'STATUS-4': 79,
    'STATUS-5': 80,
    'propertyTitlelabel': 81,
    'Update-property': 38,
    'btnAddRoom': 82,
    'Countrylabel':97,

    'optionroomtype-1': 86,
    'optionroomtype-2': 87,
    'optionroomtype-3': 88,
    'optionroomtype-4': 89,
    'optionroomtype-5': 90,
    'optionroomtype-6': 91,
    'optionroomtype-7': 92,
    'optionroomtype-8': 93,
    'total-rowslabel': 98,
    'emptpropertylistmessage': 100,
    'newproperty': 101,
    'toggle-tolist': 102,
    'Lease': 104
    
}

var valuearray = {
    'sign-in-button': 3,
    'sign-up-button': 4,

    'Update-basic-data': 38,
    'Update-password': 43
}

function getFlagCountry(lang) {
    const flags = {
        'English': 'US',
        'Spanish': 'ES',
        'French': 'FR',
        'German': 'DE',
        'Italian': 'IT',
        'Portuguese': 'PT',
        'Russian': 'RU',
        'Japanese': 'JP',
        'Chinese': 'CN',
        'Korean': 'KR'
    };
    return flags[lang];
}

function SetFlagCountry(lang)
{
    var inputtextlanguage = document.getElementById('inputtextlanguage');
    const arrowSvg = `<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 20 20' fill='currentColor'><path fill-rule='evenodd' d='M5.23 7.21a.75.75 0 0 1 1.06.02L10 10.94l3.71-3.71a.75.75 0 0 1 1.08 1.04l-4.25 4.25a.75.75 0 0 1-1.08 0L5.21 8.27a.75.75 0 0 1 .02-1.06z' clip-rule='evenodd'/></svg>`;
    inputtextlanguage.style.backgroundImage = "";
    inputtextlanguage.style.backgroundImage = `url("https://flagsapi.com/${getFlagCountry(lang)}/flat/64.png"), url("data:image/svg+xml,${encodeURIComponent(arrowSvg)}")`;
    document.documentElement.setAttribute('lang', getFlagCountry(lang).toLowerCase());
}


async function loadCsvPathFromAppSettings() 
{
    try 
    {
        const response = await fetch('/Getappsettingdada/GetPathComents');
        const data = await response.json();
        
        return Loadcoments(data.path);
    } 
    catch (error) 
    {
        console.error('Error loading appsettings data:', error);
    }

}

async function Loadcoments(cvsPath) 
{
    try 
    {
        const response = await fetch(cvsPath);
        const csvData = await response.text();
        
        //console.log(csvData);
        const lines = csvData.trim().split("\n");
        const headers = lines[0].split(",").map(h => h.trim());
        const rows = lines.slice(1);
        const comment = {};

        headers.forEach((header, index) => {
            comment[header] = rows.map(row => 
            {
                const cols = row.split(",");
                return cols[index] ? cols[index].trim() : "";
            });
        });
        return comment;
    } 
    catch (error) 
    {
        console.error('Error loading CSV data:', error);
    }

}

(async () => 
{
    languagearray = await loadCsvPathFromAppSettings();
    var languageunputtext = document.getElementById('inputtextlanguage');
    var languageSelect = document.getElementById('languageSelect');

    languageunputtext.value = defaultLanguage;
    
    Object.keys(languagearray).forEach(language => {
        if(language != 'index')
            languageSelect.innerHTML += `<option value="${language}" > ${language} </option>`;
    });

    var languageunputtext = document.documentElement.getAttribute('data-language');

    //addlabels(document.documentElement.getAttribute('data-language'));
    
    // Signal that language data is ready
    window.resolveLanguageLoaded();
})();

async function getindexlabel(IDList = null)
{
    await languageLoadedPromise;

    var language = document.documentElement.getAttribute('data-language')

    const setText = (id, text) => {
        const element = document.getElementById(id);
        if (element){ element.textContent = text;}
    };

    if(!IDList)
        Object.keys(indexlabel).forEach(id =>{
            setText(id, languagearray[language][indexlabel[id]])
        });
    else
        IDList.forEach(id => {setText(id, languagearray[language][indexlabel[id]]);});
}

async function getvaluelabel(IDList = null)
{
    await languageLoadedPromise;
    var language = document.documentElement.getAttribute('data-language')

    const setTextInputValue = (id, text) => {
        const el = document.getElementById(id);
        if (el) el.value = text;
    }

    if(!IDList)
        Object.keys(valuearray).forEach(id => {
            setTextInputValue(id, languagearray[language][valuearray[id]]);
        });
    else
        IDList.forEach(id => setTextInputValue(id, languagearray[language][valuearray[id]]))
}
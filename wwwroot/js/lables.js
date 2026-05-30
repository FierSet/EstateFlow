
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
    'username-login': 5,
    'password-login': 6,
    'keep-signed-in': 7,
    'forgot-password-link': 9,
    'username-signup': 5,
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
    'Logout': 31
}

var valuearray = {
    'sign-in-button': 3,
    'sign-up-button': 4
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
        if (element) element.textContent = text;
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
/*

function addlabels(defaultLanguage)
{
    if (!languagearray || !languagearray[defaultLanguage]) {
        console.warn('Language data not available for', defaultLanguage);
        return;
    }

    // Helper to safely set textContent
    const setText = (id, text) => {
        const el = document.getElementById(id);
        if (el) el.textContent = text;
    };

    const setTextInputValue = (id, text) => {
        const el = document.getElementById(id);
        if (el) el.value = text;
    }


    var labelmatrix_textContent = [
        ['hometitle', 0],
        ['hometitlefooter', 0],
        ['homeLink', 1],
        ['privacyLink', 2],

        ['sign-in-label', 3],
        ['sign-up-label', 4],
        ['username-login', 5],
        ['password-login', 6],
        ['keep-signed-in', 7],
        ['forgot-password-link', 9],
        ['username-signup', 5],
        ['password-signup', 6],
        ['repeat-password-signup', 8],
        ['email-address', 11],
        ['already-member-label', 10]
    ];

    var labelmatrix_inputValue = [
        ['sign-in-button', 3],
        ['sign-up-button', 4]
    ];


    labelmatrix_textContent.forEach(([id, index]) => setText(id, languagearray[defaultLanguage][index]));
    labelmatrix_inputValue.forEach(([id, index]) => setTextInputValue(id, languagearray[defaultLanguage][index]));
}

*/
// Please see documentation at https://learn.microsoft.com/aspnet/core/client-side/bundling-and-minification
// for details on configuring this project to bundle and minify static web assets.

// Write your JavaScript code.

var defaultLanguage = "English";
var defaultTheme = "dark";


function loadstart()
{

    const switch_dark_mode = document.getElementById('darkModeToggle').querySelector('input[type="checkbox"]');
    switch_dark_mode.checked = defaultTheme === 'dark';
    
    document.documentElement.setAttribute('data-theme', switch_dark_mode.checked ? 'dark' : 'light');
    document.documentElement.setAttribute('data-language', defaultLanguage);
    SetFlagCountry(defaultLanguage);
    //document.getElementById('languageFlag').innerHTML = `<img src="https://flagsapi.com/${getFlagCountry(defaultLanguage)}/flat/64.png">`;
}

function darkMode() 
{
    const currentTheme = document.documentElement.getAttribute('data-theme');
    const newTheme = currentTheme === 'dark' ? 'light' : 'dark';
    document.documentElement.setAttribute('data-theme', newTheme);

}

function ChangeLanguage(language) 
{
    document.documentElement.setAttribute('data-language', language);
    //defaultLanguage = language;
}

async function ChangeSinglePartial (partialfunc, partialPath, idtarget) 
{
    return fetch(`${partialfunc}=${partialPath}`)
    .then(response => response.text())
    .then(navHtml => 
    {

        document.getElementById(idtarget).innerHTML = navHtml;

    }).catch(err => console.error("Error loading partial:", err));
}

function IsValidEmail(Email)
{
    const Email_format = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;

    return Email_format.test(Email)
}

function Are_equal(id1, id2)
{
    var data1 = document.getElementById(id1).value
    var data2 = document.getElementById(id2).value

    if(data1 === data2)
        return true

    return false
}

function togglePassword(id, btn, icons) {

    const passwordInput =
        document.getElementById(id);
    const botton = document.getElementById(btn);

    const icon = document.getElementById(icons);

    if(passwordInput.type = passwordInput.type === "password")
    {
        passwordInput.type = "text"
        icon.classList.remove("fa-eye");
        icon.classList.add("fa-eye-slash");
    }
    else
    {
        passwordInput.type = "password"
        icon.classList.remove("fa-eye-slash");
        icon.classList.add("fa-eye");
    }
}

function Loadcreen(idtarget)
{
    var container = document.getElementById(idtarget);
    if (!container) return;

    var loadscreen = `<div id="loadingScreen">
                        <div class="spinner"></div>
                    </div>`;
    
    var haveloadscreen = container.querySelector("#loadingScreen");
    if(haveloadscreen)
        container.removeChild(haveloadscreen);
    else
        container.innerHTML += loadscreen;
}

// Add focus and blur events for language input
const languageInput = document.getElementById('inputtextlanguage');
languageInput.addEventListener('focus', () => {
    if (languageInput.value === defaultLanguage || languageInput.value === document.documentElement.getAttribute('data-language')) {
        languageInput.value = '';
    }
});

languageInput.addEventListener('blur', () => {
    if (languageInput.value === '') {
        languageInput.value = document.documentElement.getAttribute('data-language');
    }
});

// Add change event for language input
languageInput.addEventListener('change', () => 
{
    if (languagearray[languageInput.value]) 
    {
        const selectedLanguage = languageInput.value;
        ChangeLanguage(selectedLanguage);
        SetFlagCountry(document.documentElement.getAttribute('data-language'));
    }
    else
    {
        languageInput.value = document.documentElement.getAttribute('data-language');
    }
    
});
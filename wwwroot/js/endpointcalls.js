function testDatabaseConnection(deploy_in) 
{
    const resultElement = document.getElementById(deploy_in);
    
    resultElement.innerHTML = '<a class="orange-dot"></a>';

    fetch('/api/Database/test-connection')
        .then(response => response.json())
        .then(data => {
            
            if (data.status === 200)
            {
                resultElement.textContent = 'DB';
                resultElement.innerHTML += '<a class="green-dot"></a>';
                if(resultElement.querySelector('red-dot'))
                    resultElement.removeChild('red-dot');
            }
            else throw new Error('DB Offline');
    })
    .catch(error => {
        resultElement.textContent = 'DB';
        resultElement.innerHTML += '<a class="red-dot"></a>';
        if(resultElement.querySelector('green-dot'))
            resultElement.removeChild('green-dot');
    });
}

async function signin(idemail, idpassword, iderror)
{
    var Email = document.getElementById(idemail);
    var Password = document.getElementById(idpassword);
    var errorlend = document.getElementById('error-signin');

    var errorMessage = errorlend.querySelector('#singin-message-error');

    var errorcode = [16,17,18, 20, 21, 23];

    if(errorMessage)
    {
        errorlend.removeChild(errorMessage)
        Email.classList.remove('border-red');
        Password.classList.remove('border-red');
    }

    if(!IsValidEmail(Email.value))
    {
        errorlend.innerHTML += `<p id='singin-message-error'> </p>`;
        Email.classList.add('border-red');
        indexlabel['singin-message-error'] = 15;
        getindexlabel(['singin-message-error']);
        
        return 0;
    }

    const response = await fetch('/Home/Loggin', { //'/api/Database/Signin'
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ Email: Email.value, Password: Password.value })
    });

    var jsonresponse = await response.json();
    var jsoncodes = JSON.parse(jsonresponse.jsonresponse);
    
    if(errorcode.includes(jsoncodes.code))
    {
        errorlend.innerHTML += `<p id='singin-message-error'> </p>`;
        indexlabel['singin-message-error'] = jsoncodes.code;
        getindexlabel(['singin-message-error']);
    }
    else
    {
        errorlend.innerHTML += `<p id='singin-message-error' style='color:green; !important'> </p>`;
        indexlabel['singin-message-error'] = jsoncodes.code;
        window.location = '/Customer/Customer';
        //getindexlabel(['singin-message-error']);
    }

}

async function signup(email, password1, password2, error)
{
    var errorlend = document.getElementById(error);
    var Email = document.getElementById(email);
    var Password = document.getElementById(password1);
    var Password2 = document.getElementById(password2);

    var errorcode = [16,17,18, 20, 21];

    var errorMessage = errorlend.querySelector('#singun-message-error')
    if(errorMessage)
    {
        Email.classList.remove('border-red');
        Password.classList.remove('border-red');
        Password2.classList.remove('border-red');
        errorlend.removeChild(errorMessage)
    }

    if(!IsValidEmail(Email.value))
    {
        errorlend.innerHTML += `<p id='singun-message-error'> </p>`;
        Email.classList.add('border-red');
        indexlabel['singun-message-error'] = 15;
        getindexlabel(['singun-message-error']);
        return 0;
    }
    
    if(!Are_equal(password1, password2))
    {
        errorlend.innerHTML += `<p id='singun-message-error'> </p>`;
        Password.classList.add('border-red');
        Password2.classList.add('border-red');
        indexlabel['singun-message-error'] = 14;
        getindexlabel(['singun-message-error']);
        return 0;
    }

    const response = await fetch('/Home/Signup', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ Email: Email.value, Password: Password.value })
    });

    var jsonresponse = await response.json();
    var jsoncodes = JSON.parse(jsonresponse.jsonresponse);
    
    if(errorcode.includes(jsoncodes.code))
    {
        errorlend.innerHTML += `<p id='singun-message-error'> </p>`;
        indexlabel['singun-message-error'] = jsoncodes.code;
        getindexlabel(['singun-message-error']);
        return 0;
    }
    else
    {
        errorlend.innerHTML += `<p id='singun-message-error' style='color:green; !important'> </p>`;
        indexlabel['singun-message-error'] = jsoncodes.code;
        getindexlabel(['singun-message-error']);
        var Email = document.getElementById(email).value = "";
        var Password = document.getElementById(password1).value = "";
        var Password2 = document.getElementById(password2).value = "";
        return 0;
    }


}
function userdataform()
{
    const form = document.getElementById("profileform");
    const regex = /^\(?\d{3}\)?[-.\s]?\d{3}[-.\s]?\d{4}$/;
    
    //indexlabel["Phoneerror"] = document.getElementById("Phoneerror").value == null ? 51: 52;
    let isvalid = true;
    
    for(const element of form.elements)
    {   
        let spanid = element.id + 'error';
        var span = document.getElementById(spanid);
        if(element.value == null || element.value == "")
        {
            
            element.classList.add("input-validation-error");
            span.hidden = false;
            indexlabel["Phoneerror"] = 51;
            getindexlabel([element.id + "error"])
            isvalid = false;
        }
        else if (element.id =="Phone")
        {
            if(!regex.test(element.value))
            {
                indexlabel[element.id + "error"] = 52;
                element.classList.add("input-validation-error");
                span.hidden = false;
                getindexlabel([element.id + "error"])
                isvalid = false;
            }
            
        }
        else
        {
            if(span)
                span.hidden = true;
            element.classList.remove("input-validation-error");
        }
        
    }
    return isvalid;
}

function changepasswordcheck()
{
    const form = document.getElementById("userpassword");


    let isvalid = true;

    for(const element of form.elements)
    {
        let spanid = element.id + 'error';
        var span = document.getElementById(spanid);
        if(element.value == null || element.value == "")
        {
            element.classList.add("input-validation-error");
            span.hidden = false;
            indexlabel["Password2error"] = 53;
            getindexlabel([element.id + "error"]);
            isvalid = false;
        }
        else if(element.id == "Password2")
        {
            if(document.getElementById("Password1").value != element.value)
            {
                element.classList.add("input-validation-error");
                span.hidden = false;
                indexlabel[element.id + "error"] = 54;
                getindexlabel([element.id + "error"]);
                isvalid = false;
            }
        }
        else
        {
            if(span)
                span.hidden = true;
            element.classList.remove("input-validation-error");
        }
    }

    return isvalid;
}
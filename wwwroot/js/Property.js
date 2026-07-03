let roomIndex = 0;
let page = 1;
var propertyarray = [];

function baseroom(index, roomlisttype)
{
    const defaultimg ="../IMG/room/room-base.png";
    return `
        <div id="room-${index}" class="room">

            <div id="header-Room-${index}" class="header-Room">
                <Label id="Room-label-${index}">Room </Label> <button type="button" id="header-button-${roomIndex}" class="remove-button" onclick="removeroom('${roomIndex}');">
                    <i class="fa-solid fa-trash"></i>
                </button>
            </div>
            <div class="room-base">
                <img id="Room-Image-${index}" src="${defaultimg}" />
                <div id="room-input-${index}" class="room-input"> 
                    <input id="RoomID-${index}" type="hidden" name="Property.Rooms[${index}].RoomID" />
                    <input id="PropertyID-${index}" type="hidden" name="Property.Rooms[${index}].PropertyID" />
                    <input id="Remove-${index}" type="hidden" name="Property.Rooms[${index}].Remove" value="false"/>
                    <div class="group-property">
                        <label id="Sizelabel-${index}" for="Size">Size</label>
                        <input id="Size-${index}" type="number" step="0.01" name="Property.Rooms[${roomIndex}].Size" />
                    </div>
                    
                    <div class="group-property">
                        <label id="Descriptionlabel-${index}" for="Description">Description</label>
                        <textarea id="Description-${index}"  name="Property.Rooms[${index}].Description" rows="2" cols="50"></textarea>
                     </div>

                    <div class="group-property">
                        <label id="RoomTypelabel-${index}" for="RoomsType-${index}">RoomType</label>
                        <SELECT id="RoomType-${index}" name="Property.Rooms[${index}].RoomType">
                            ${roomlisttype.replaceAll("ids",index)}
                        </SELECT>
                    </div>

                    <div class="group-property">
                        <label id="Imageurllabel-${roomIndex}" for="Imageurl">Imageurl</label>
                        <input id="Imageurl-${roomIndex}" type="text" name="Property.Rooms[${roomIndex}].Imageurl" />
                    </div>
                </div>
                
            </div>
        </div>`;
}

function propertyunit(jsons)
{
    var rooms = [];
    var roomcount = "";

    jsons.Rooms.forEach(room => {
        if(rooms[room.RoomTypeName] == null)
        {
            rooms[room.RoomTypeName] = 0;
        }
        rooms[room.RoomTypeName]++;
    });

    Object.keys(rooms).forEach(roomType => {

        roomcount += `${roomType}: ${rooms[roomType]}<br>`;
    });

    return `

        <div id="property-list-${jsons.PropertyID}" class="property-unit-list">

            <div id="property-base-${jsons.PropertyID}" class="property-base">
                <img id="property-Image-${jsons.PropertyID}" src="${jsons.Imageurl}" />
                <div id="property-input-${jsons.PropertyID}" class="property-input"> 
                    
                    <div class="group-propertylist">
                        <label id="Title-${jsons.PropertyID}" class="title">${jsons.Title}</label>
                    </div>
                    
                    <div class="group-propertylist">
                        <label id="Address-property-${jsons.PropertyID}">
                            ${jsons.Country + "," + jsons.State + "," + 
                                jsons.City + "," + jsons.Address + "," + 
                                jsons.ZipCode}
                        </label>
                    </div>

                    <div class="group-propertylist">
                        <label id="PropertyType-property-${jsons.PropertyID}">${jsons.PropertyType}</label>
                    </div>

                    <div class="group-propertylist">
                        <label id="AREA-property-${jsons.PropertyID}">${jsons.AREA}</label>
                    </div>

                    <div class="group-propertylist">
                        <label id="STATUS-property-${jsons.PropertyID}">${jsons.STATUS}</label>
                    </div>

                    <div class="group-propertylist">
                        <label id="RentPrice-property-${jsons.PropertyID}">${jsons.RentPrice}</label>
                    </div>

                    <div class="group-propertylist">
                        <label id="SalePrice-property-${jsons.PropertyID}">${jsons.SalePrice}</label>
                    </div>

                    <div class="group-propertylist">
                        <label id="rooms-property-${jsons.PropertyID}">${roomcount}</label>
                    </div>

                </div>
                
            </div>
        </div>
    
    `;
}

function addroom(roomlisttype)
{
    const room = baseroom(roomIndex, roomlisttype);

    document.getElementById("property-List-room")
        .insertAdjacentHTML("beforeend", room);

    indexlabel[`Room-label-${roomIndex}`] = 83;
    indexlabel[`Sizelabel-${roomIndex}`] = 84;
    indexlabel[`Descriptionlabel-${roomIndex}`] = 59;
    indexlabel[`RoomTypelabel-${roomIndex}`] = 85;
    indexlabel[`Imageurllabel-${roomIndex}`] = 70;

    indexlabel[`RoomTypes-1-${roomIndex}`] = 86;
    indexlabel[`RoomTypes-2-${roomIndex}`] = 87;
    indexlabel[`RoomTypes-3-${roomIndex}`] = 88;
    indexlabel[`RoomTypes-4-${roomIndex}`] = 89;
    indexlabel[`RoomTypes-5-${roomIndex}`] = 90;
    indexlabel[`RoomTypes-6-${roomIndex}`] = 91;
    indexlabel[`RoomTypes-7-${roomIndex}`] = 92;
    indexlabel[`RoomTypse-8-${roomIndex}`] = 93;
    
    getindexlabel(
        [
        `Room-label-${roomIndex}`, `Sizelabel-${roomIndex}`, `Descriptionlabel-${roomIndex}`,
        `RoomTypelabel-${roomIndex}`, `Imageurllabel-${roomIndex}`,
        `RoomTypes-1-${roomIndex}`,
        `RoomTypes-2-${roomIndex}`,
        `RoomTypes-3-${roomIndex}`,
        `RoomTypes-4-${roomIndex}`,
        `RoomTypes-5-${roomIndex}`,
        `RoomTypes-6-${roomIndex}`,
        `RoomTypes-7-${roomIndex}`,
        `RoomTypes-8-${roomIndex}`
        ]
    );

    roomIndex++;

}

function removeroom(IDROOM)
{
    var room = document.getElementById(`room-${IDROOM}`);
    var roomid = document.getElementById(`RoomID-${IDROOM}`);
    var header = document.getElementById(`header-Room-${IDROOM}`);
    var removemessage = `<Label id="labelremove-room-${IDROOM}" class="labelremove">Remove</Label>`;

    if(roomid.value != null)
        room.remove();
    else    
    {
        header.innerHTML += removemessage;
        document.getElementById(`Remove-${IDROOM}`).value = true;
    }
}

async function loadpropertyList(movement)
{
    var propertylist = document.getElementById('properties-list');
    var id = parseInt(document.getElementById("ID").value);
    var totalpages = document.getElementById("total-pages");

    var totalrows = document.getElementById("total-rows");

    var pagescount = document.getElementById("property-currentpage");

    if(page + movement <= 0 || page + movement > parseInt(totalpages))
        return;

    var data = {
        "Usercreids": {
            "ID": id
        },
        "Page": page
    }

    try
    {
        const response = await fetch('/MyProperties/Loadproperties', { //'/api/Database/Signin'
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify( data)
        })
        .then(response => response.json())
        .then(data => {
             
            return data;
        });

        var PageInfo = JSON.parse(response["PageInfo"]);

        totalrows.textContent = PageInfo.TotalRows;
        pagescount.textContent = PageInfo.Page + "/" + PageInfo.TotalPages;

        var propertylisthtml = Array.isArray(response["Properties"]) ? response["Properties"] : [];

        console.log(propertylisthtml);
        propertylisthtml.forEach(property => {
            
            
            propertyarray.push(property);
            propertylist.insertAdjacentHTML("beforeend", propertyunit(property));

        });

    }
    catch(err)
    {
        console.log(err);
    }
}

async function uploadproperty()
{
    const userid = document.getElementById("usercredentials").querySelectorAll("input");
    
    const property = document.getElementById("property-edit-property")
    .querySelectorAll("input, select, textarea");

    const rooms = document.getElementById("property-List-room").querySelectorAll(".room");
    //.querySelectorAll("input, select, textarea");
    
    const data = {
        Usercreids: {},
        Property: {
            Rooms: []
        },
    };
    
    userid.forEach(element => {
        data.Usercreids[element.id] = element.id == "ID" ? Number(element.value) : element.value;
    });
    data.Usercreids["IsActive"] = true;
    property.forEach(element => {
        data.Property[element.id] = 
            element.value !== "" &&
            (element.id == "PropertyID" || element.type == "number" || element.tagName == "SELECT") ? 
            Number(element.value) : element.value == "" ? null : element.value;
    });
    rooms.forEach(room => {
        var subdata = {};
        room.querySelectorAll("input, select, textarea").forEach(element =>{
            subdata[element.id.replace(/-[^-]+$/, "")] = 
            element.value !== "" && 
            (element.id.replace(/-[^-]+$/) == "RoomID" ||
            element.id.replace(/-[^-]+$/) == "PropertyID" ||
            element.type == "number" || element.tagName == "SELECT") ? 
            Number(element.value): element.value == "" ? null : element.value;
        });
        data.Property.Rooms.push(subdata);
    });
    console.log(data);
    try
    {
       
        const response = await fetch('/MyProperties/Updateproperties', { //'/api/Database/Signin'
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify( 
                {
                    Usercreids: data.Usercreids,
                    Property: data.Property,
                }
            )
        })
        .then(response => response.json())
        .then(data => {
             console.log(data)
             if (data.status !== 200)
                throw new Error("Conection error")
            return data;
        });
        
        
    }
    catch(err)
    {
        console.log(err);
    }

    
    return false;
}
let roomIndex = 0;
let page = 1;
var propertyarray = [];
let roomtypelist = [];
var totalpages = 1;
var roomytypeoptions = "";
var hidecreateproperty = true;
var defaulthouseicon = "../IMG/Home/No_Imagen_House.png";
var defaultroomicon = "../IMG/room/No_Imagen_Room.png";

function toggleshowproperty()
{
    hidecreateproperty = !hidecreateproperty;
    showpropertycreation(hidecreateproperty);
}

function showpropertycreation(IShidden)
{
   
    indexlabel["toggle-tolist"] = IShidden ? 102: 103;
    getindexlabel(["toggle-tolist"]);
    const propertycreation = document.getElementById('upload-edid-property').hidden = IShidden;
    const propertylist = document.getElementById('property-list').hidden = !IShidden;

}

function baseroom(index)
{
    const template = document.getElementById("RoomTypeOptions");
    const newSelect = template.innerHTML;

    const defaultimg ="../IMG/room/room-base.png";
    return `
        <div id="room-${index}" class="room">

            <div id="header-Room-${index}" class="header-Room">
                <Label id="Room-label-${index}">Room </Label> <button type="button" id="header-button-${index}" class="remove-button" onclick="removeroom('${index}');">
                    <i class="fa-solid fa-trash"></i>
                </button>
            </div>
            <div class="room-base">
                <img id="Room-Image-${index}" src="${defaultimg}" />
                <div id="room-input-${index}" class="room-input"> 
                    <input id="RoomID-${index}" type="hidden" name="Property.Rooms[${index}].RoomID" />
                    <input id="PropertyID-${index}" type="hidden" name="Property.Rooms[${index}].PropertyID" />
                    <input id="Remove-${index}" type="hidden" name="Property.Rooms[${index}].Remove" value="0"/>
                    <div class="group-property">
                        <label id="Sizelabel-${index}" for="Size">Size</label>
                        <input id="Size-${index}" type="number" step="0.01" name="Property.Rooms[${index}].Size" value="0"/>
                    </div>
                    
                    <div class="group-property">
                        <label id="Descriptionlabel-${index}" for="Description">Description</label>
                        <textarea id="Description-${index}"  name="Property.Rooms[${index}].Description" rows="2" cols="50"></textarea>
                     </div>

                    <div class="group-property">
                        <label id="RoomTypelabel-${index}" for="RoomsType-${index}">RoomType</label>
                        <SELECT id="RoomType-${index}" name="Property.Rooms[${index}].RoomType">
                            ${newSelect.replaceAll("ids",index)}
                        </SELECT>
                    </div>

                    <div class="group-property">
                        <label id="Imageurllabel-${index}" for="Imageurl-${index}">Imageurl</label>
                        <input id="Imageurl-${index}" type="text" name="Property.Rooms[${index}].Imageurl" class="Imageurl" data-preview="Room-Image-${index}"/>
                    </div>
                </div>
                
            </div>
        </div>`;
}

function propertyunit(jsons)
{
    var rooms = [];
    var roomcount = "";

    jsons.Rooms.forEach(room => { // count the type room
        
        if(rooms[room.RoomType] == null)
            rooms[room.RoomType] = 0;
        rooms[room.RoomType]++;
    });

    araysrooms = [];

    Object.keys(rooms).forEach(roomType => {

        let idlabel = `optionroomtype-${roomType}`;
        let idstring = `${idlabel}-${jsons.PropertyID}`;
        roomcount += `<span> <span id="${idstring}"> </span>: ${rooms[roomType]}</span>`;
        araysrooms.push(idstring);
        indexlabel[idstring] = indexlabel[idlabel];
    });

    let propertyid = `PropertyType-${jsons.PropertyType}`;
    let propertytypelabel = `${propertyid}-${jsons.PropertyID}`;
    araysrooms.push(propertytypelabel);
    indexlabel[propertytypelabel] = indexlabel[propertyid];

    let statusid = `STATUS-${jsons.STATUS}`;
    let statuslabel = `${statusid}-${jsons.PropertyID}`;
    araysrooms.push(statuslabel);
    indexlabel[statuslabel] = indexlabel[statusid];

    let rentid = "RentPricelabel";
    let reentlabel = `${rentid}-property-${jsons.PropertyID}`;
    araysrooms.push(reentlabel);
    indexlabel[reentlabel] = indexlabel[rentid];

    let saleid = "SalePricelabel";
    let salelabel = `${saleid}-property-${jsons.PropertyID}`;
    araysrooms.push(salelabel);
    indexlabel[salelabel] = indexlabel[saleid];

    return [`
        <div id="property-list-${jsons.PropertyID}" class="property-unit-list" onclick="selectproperty(${jsons.PropertyID})">

            <div id="property-base-${jsons.PropertyID}" class="property-base">
                <img id="property-Image-${jsons.PropertyID}" src="${jsons.Imageurl}" />
                <div id="property-input-${jsons.PropertyID}" class="property-input"> 
                    
                    <div class="group-propertylist titles">
                        <label id="Title-${jsons.PropertyID}" class="title">${jsons.Title}</label>
                    </div>
                    
                    <div class="group-propertylist">
                        <span id="Address-property-${jsons.PropertyID}">
                            ${jsons.Country + ", " + jsons.State + ", " + 
                                jsons.City + ", " + jsons.Address + ", " + 
                                jsons.ZipCode}
                        </span>
                    </div>

                    <div class="group-propertylist">
                        <span id="${propertytypelabel}"> </span>
                    </div>

                    <div class="group-propertylist">
                        <span id="AREA-property-${jsons.PropertyID}"> ${jsons.AREA} m&sup2;</span>
                    </div>

                    <div class="group-propertylist">
                        <label id="${statuslabel}">${jsons.STATUS}</label>
                    </div>

                    <div class="group-propertylist">
                        <span id="${reentlabel}">Rent</span> <span>: $${jsons.RentPrice}</span>
                    </div>

                    <div class="group-propertylist">
                        <span id="${salelabel}">Sale</span> <span>: $${jsons.SalePrice}</span>
                    </div>

                    <div class="group-propertylist rooms">
                        ${roomcount}
                    </div>

                </div>
                
            </div>
        </div>
    `, araysrooms];
}

function addroom()
{
    const room = baseroom(roomIndex);

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
        `RoomTypes-1-${roomIndex}`, `RoomTypes-2-${roomIndex}`, 
        `RoomTypes-3-${roomIndex}`, `RoomTypes-4-${roomIndex}`, 
        `RoomTypes-5-${roomIndex}`, `RoomTypes-6-${roomIndex}`,
        `RoomTypes-7-${roomIndex}`, `RoomTypes-8-${roomIndex}`
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
    var isremove = document.getElementById(`Remove-${IDROOM}`);
    if(roomid.value == null)
        room.remove();
    else    
    {
        if(isremove.value == 0)
        {
            header.innerHTML += removemessage;
            isremove.value = 1;
        }
        else
        {
            const removelabel = document.getElementById(`labelremove-room-${IDROOM}`);
            header.removeChild(removelabel);
            isremove.value = 0;
        }
    }
}

async function loadpropertyList(movement)
{
    propertyarray = [];
    var propertylist = document.getElementById('properties-list');
    var id = parseInt(document.getElementById("ID").value);
    var totalrows = document.getElementById("total-rows");
    var pagescount = document.getElementById("property-currentpage");

    if(page + movement <= 0 || page + movement > parseInt(totalpages))
        return;

    page += movement;
    propertylist.replaceChildren();
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
             //console.log(data);
            return data;
        });

        var json = JSON.parse(response);
        var PageInfo = JSON.parse(json["PageInfo"]);
        
        totalrows.textContent = PageInfo["TotalRows"];
        totalpages = PageInfo["TotalPages"];
        pagescount.textContent = PageInfo["Page"] + "/" + PageInfo["TotalPages"];
        
        
        var propertylisthtml = Array.isArray(json["Properties"]) ? json["Properties"] : [];
        if(propertylisthtml.length  > 0)
        {
            propertylisthtml.forEach(property => {
                
                 property.Rooms?.forEach(room => {
                    room.Remove = 0;
                });
                propertyarray.push(property);
                let [propertyhtml, arraysrooms] = propertyunit(property);
                propertylist.insertAdjacentHTML("beforeend", propertyhtml);
                //property-Image-${jsons.PropertyID
                document.getElementById(`property-Image-${property.PropertyID}`).onerror = function () {
                    this.src = defaultroomicon;
                };

                getindexlabel(arraysrooms);

            });
        }
        else
        {
            propertylist.innerHTML = `<h1 id="emptpropertylistmessage"></h1>`;
            getindexlabel(['emptpropertylistmessage']);
        }

    }
    catch(err)
    {
        console.log(err);
    }
}

function selectproperty(PropertyID)
{
    hidecreateproperty = !hidecreateproperty;
    showpropertycreation(hidecreateproperty)

    const propertybyarray = propertyarray.find(p => p.PropertyID === PropertyID);

     const property = document.getElementById("property-editall")
    .querySelectorAll("input, select, textarea, img");

    const rooms = document.getElementById("property-List-room");
    rooms.replaceChildren();

    property.forEach(element => {
        
        if(element.id != "ID" && element.id != "Email")
        {
            element.value = propertybyarray[element.id];
            if(element.tagName == "IMG")
            {
                element.src = propertybyarray["Imageurl"];
                element.onerror = function () {
                    this.src = defaulthouseicon;
                };
            }
        }
    });

    propertybyarray.Rooms.forEach(room => {
        rooms.insertAdjacentHTML("beforeend", baseroom(room.RoomID));

        const getroom = document.getElementById(`room-${room.RoomID}`).querySelectorAll("input, select, textarea, img");
        getroom.forEach(r => {
            r.value = room[r.id.replace(/-[^-]+$/, "")];
            if(r.tagName = "IMG")
            {
                r.src = room["Imageurl"];
                r.onerror = function () {
                    this.src = defaultroomicon;
                };
            }
        });
    });
    
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
            (element.id.replace(/-[^-]+$/, "") == "RoomID" ||
            element.id.replace(/-[^-]+$/, "") == "PropertyID" ||
            element.type == "number" || element.tagName == "SELECT") ? 
            Number(element.value): element.value == "" ? null : element.value;
        });
        data.Property.Rooms.push(subdata);
    });

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
            
            indexlabel['property-message'] = data['messagecode.Code'];
            getindexlabel(['property-message']);
            return data;
        });
        
        cleanpropertyedit();
        hidecreateproperty = !hidecreateproperty;
        showpropertycreation(hidecreateproperty)
        loadpropertyList(0);

    }
    catch(err)
    {
        console.log(err);
    }
}

function cleanpropertyedit()
{
    const propertydelete = document.getElementById("property-edit-property").querySelectorAll("input, select, textarea");
    const roomstodelete = document.getElementById("property-List-room").replaceChildren();

    propertydelete.forEach(element => {
        element.value = null;
    });
}

document.addEventListener("input", function (e) {
    
    if (!e.target.matches(".Imageurl"))
        return;

    const imageId = e.target.dataset.preview;
    const image = document.getElementById(imageId);

    if (image) {
        image.src = e.target.value;
    }
});
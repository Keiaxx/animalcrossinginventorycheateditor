import QtQuick 2.12
import QtQml 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 1.4 as Controls1
import QtQuick.Controls 2.12
import gose.JsonFile 1.0
import SortFilterProxyModel 0.2
import Qt.labs.settings 1.1
import QtQuick.Dialogs 1.2

Window {
    id: root
    visible: true
    minimumWidth: 1500
    minimumHeight: 800
    width: 1500
    height: 580
    title: qsTr("Animal Crossing Inventory Editor")

    property string selectedItemName: ''
    property string selectedItemHexstr: ''
    property string selectedItemDetail: ''
    property string selectedItemdiyid: ''
    property int selectedItemCount: 1
    property bool movementEnabled: false
    property string ftpString: "ftp://192.168.86.41:5000/sxos/titles/01006f8002326000/cheats/fdc1632048facfbd.txt"

    // Old pre 1.2.0 offsets
    //readonly property var itemOffsets: ["AC3B90C0 AC3B90C4", "AC3B90C8 AC3B90CC", "AC3B90D0 AC3B90D4", "AC3B90D8 AC3B90DC", "AC3B90E0 AC3B90E4", "AC3B90E8 AC3B90EC", "AC3B90F0 AC3B90F4", "AC3B90F8 AC3B90FC", "AC3B9100 AC3B9104", "AC3B9108 AC3B910C", "AC3B9110 AC3B9114", "AC3B9118 AC3B911C", "AC3B9120 AC3B9124", "AC3B9128 AC3B912C", "AC3B9130 AC3B9134", "AC3B9138 AC3B913C", "AC3B9140 AC3B9144", "AC3B9148 AC3B914C", "AC3B9150 AC3B9154", "AC3B9158 AC3B915C", "AC3B9008 AC3B900C", "AC3B9010 AC3B9014", "AC3B9018 AC3B901C", "AC3B9020 AC3B9024", "AC3B9028 AC3B902C", "AC3B9030 AC3B9034", "AC3B9038 AC3B903C", "AC3B9040 AC3B9044", "AC3B9048 AC3B904C", "AC3B9050 AC3B9054", "AC3B9058 AC3B905C", "AC3B9060 AC3B9064", "AC3B9068 AC3B906C", "AC3B9070 AC3B9074", "AC3B9078 AC3B907C", "AC3B9080 AC3B9084", "AC3B9088 AC3B908C", "AC3B9090 AC3B9094", "AC3B9098 AC3B909C", "AC3B90A0 AC3B90A4"]

    // For 1.2.0 offsets
    //readonly property var itemOffsets: ["AC4723D0", "AC4723D8", "AC4723E0", "AC4723E8", "AC4723F0", "AC4723F8", "AC472400", "AC472408", "AC472410", "AC472418", "AC472420", "AC472428", "AC472430", "AC472438", "AC472440", "AC472448", "AC472450", "AC472458", "AC472460", "AC472468", "AC472318", "AC472320" , "AC472328", "AC472330", "AC472338", "AC472340", "AC472348", "AC472350", "AC472358", "AC472360", "AC472368", "AC472370", "AC472378", "AC472380", "AC472388", "AC472390", "AC472398", "AC4723A0", "AC4723A8", "AC4723B0"]

    // For 1.3.0 offsets
    readonly property var itemOffsets: [ 'ABA526A8',
        'ABA526B0',
        'ABA526B8',
        'ABA526C0',
        'ABA526C8',
        'ABA526D0',
        'ABA526D8',
        'ABA526E0',
        'ABA526E8',
        'ABA526F0',
        'ABA526F8',
        'ABA52700',
        'ABA52708',
        'ABA52710',
        'ABA52718',
        'ABA52720',
        'ABA52728',
        'ABA52730',
        'ABA52738',
        'ABA52740',
        'ABA525F0',
        'ABA525F8',
        'ABA52600',
        'ABA52608',
        'ABA52610',
        'ABA52618',
        'ABA52620',
        'ABA52628',
        'ABA52630',
        'ABA52638',
        'ABA52640',
        'ABA52648',
        'ABA52650',
        'ABA52658',
        'ABA52660',
        'ABA52668',
        'ABA52670',
        'ABA52678',
        'ABA52680',
        'ABA52688' ]

    Settings{
        id: settings
        property alias ftpString: root.ftpString
    }

    MessageDialog{
        id: messageDialog2
        title: "Message"
        onAccepted: {
            messageDialog.close()
        }

    }

    Popup {
        id: messageDialog
        x: parent.width/2 - width/2
        y: parent.height/2 - height/2
        width: 400
        height: 200
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

        property string text: ''

        background: Rectangle {
            radius: 5
            color: "gray"
            Text {
                anchors.centerIn: parent
                id: messageDial
                text: messageDialog.text
            }

            Button{
                anchors.bottom: parent.bottom
                height: 20
                onClicked: {
                    messageDialog.close()
                }
                text: "Close"
            }
        }
    }

    Connections{
        target: fileHandler

        onNetworkDone: {
            messageDialog.text = message
            messageDialog.open()

            connectTimeout.stop()
        }

        onNetworkError: {
            messageDialog.text = message
            messageDialog.open()

            connectTimeout.stop()
        }
    }

    Timer{
        id: connectTimeout

        onTriggered: {
            messageDialog.text = "Unable to connect to your switch!"
            messageDialog.open()
        }

        interval: 5

    }

    function getSetAsJsonOnly() {
        let inJson = []

        for(var i = 0; i < 40; i++){
            let element = inventory.get(i)
            let hexstr = element.hexstr
            let count = element.count-1
            let counthex = count.toString(16).toUpperCase()

            inJson.push({
                            name: element.name,
                            detail: element.detail,
                            hexstr: element.hexstr,
                            diyid: element.diyid,
                            count: element.count,
                            gridId: element.gridId
                        })

        }

        console.log(JSON.stringify(inJson))

        return inJson
    }

    function ensureSaveable() {

        let numitems = 0


        for(var i = 0; i < 40; i++){
            let element = inventory.get(i)
            let hexstr = element.hexstr
            let count = element.count-1
            let counthex = count.toString(16).toUpperCase()

            if(hexstr !== ''){
                numitems ++
            }
        }

        if(numitems > 0){
            return true
        }else{
            return false
        }
    }

    function generateAndUpload() {
        let lines = ["[ItemSet ACITEMCHEATMAKER]"]

        let numitems = 0

        let inJson = []

        for(var i = 0; i < 40; i++){
            let element = inventory.get(i)
            let hexstr = element.hexstr
            let count = element.count-1
            let counthex = count.toString(16).toUpperCase()

            inJson.push({
                            name: element.name,
                            detail: element.detail,
                            hexstr: element.hexstr,
                            count: element.count,
                            gridId: element.gridId
                        })

            if(hexstr !== ''){
                let offsets = itemOffsets[i]
                let top = offsets.split(" ")[0]
                let bot = offsets.split(" ")[1]


                lines.push("04100000 "+top+" "+hexstr)
                lines.push("04100000 "+bot+" "+(new Array(9-counthex.length).join("0")+counthex))

                console.log(lines)
                numitems ++
            }
        }

        if(numitems > 0){
            generatedJson.text = JSON.stringify(inJson)
            messageDialog.text = "Connecting to switch..."
            messageDialog.open()
            fileHandler.generate(ftpString, lines)
        }
    }

    function uploadAllSets() {
        let lines = []
        let sets = fileHandler.getSavedItemSets();
        let standardPath = fileHandler.getStandardPath()+"/sets/"

        if(sets.length === 0){
            messageDialog2.text = "At least one set must be saved before uploading"
            messageDialog2.open()

            return
        }

        for(var s in sets){
            let setName = sets[s]

            jsonFile.setName(standardPath+setName+".json")
            let setData = jsonFile.read()
            let data = setData.data

            let header = "[ItemSet "+setName+"]"
            lines.push(header)

            for(var i = 0; i < 40; i++){
                let element = data[i]
                let hexstr = element.hexstr
                let count = element.count-1
                let counthex = count.toString(16).toUpperCase()
                let diyid = element.diyid

                if(hexstr !== ''){
                    let offset = itemOffsets[i]

                    if(diyid){
                        lines.push("08100000 "+offset+" "+(new Array(9-diyid.length).join("0")+diyid)+" 000016A2")
                    }else{
                        lines.push("08100000 "+offset+" "+(new Array(9-counthex.length).join("0")+counthex)+" "+hexstr)
                    }
                }
            }

            lines.push("")
        }

        console.log(JSON.stringify(lines))

        messageDialog.text = "Connecting to switch..."
        messageDialog.open()
        fileHandler.generate(ftpString, lines)
    }

    ListModel {
        id: inventory
        ListElement {
            name: ''
            detail: ''
            hexstr: ''
            diyid: ''
            count: 0
            gridId: 0
        }
    }

    JsonFile {
        id: jsonFile
    }

    ListModel{
        id: itemsModel
        ListElement{
            name: 'placeholder'
            hexstr: ''
            detail: ''
            color: ''
            diyid: ''
        }
    }

    Rectangle{
        id: itemSetRegion

        height: parent.height
        width: 300

        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.rightMargin: 5

        color: "#BBBBBB"

        function refreshItemSets() {
            let sets = fileHandler.getSavedItemSets()

            setsModel.clear()

            for(var set in sets){
                let rawname = sets[set]
                setsModel.append({name: rawname})
            }
        }

        Column {
            id: topHeader
            width: parent.width
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.left: parent.left

            spacing: 5

            height: 200

            TextField{
                id: setName

                maximumLength: 12

                placeholderText: "Enter set name to save as"
            }

            Button {
                text: "Save Item Set"

                onClicked: {
                    if(setName.length > 0){

                        if(ensureSaveable()){
                            jsonFile.setName(fileHandler.getStandardPath()+"/sets/"+setName.text+".json")

                            jsonFile.write({data: getSetAsJsonOnly()})

                            messageDialog2.text = "Saved item set!"

                            messageDialog2.open()

                            itemSetRegion.refreshItemSets()
                        }else{
                            messageDialog2.text = "At least 1 item must be preset to save!"

                            messageDialog2.open()
                        }


                    }else{
                        messageDialog2.text = "Set name must be at least 1 character!"

                        messageDialog2.open()
                    }
                }
            }
        }

        ListModel{
            id: setsModel
            ListElement{
                name: ""
            }
        }

        ListView {
            id: setsListView
            clip: true
            spacing: 3
            anchors { top: topHeader.bottom; bottom: parent.bottom; left: parent.left; right: parent.right }
            model: setsModel
            delegate: Rectangle{
                color: "#DDDDDD"
                height: 50
                width: parent.width
                Text { anchors.centerIn: parent; text: model.name; font.pixelSize: 16}

                MouseArea{
                    anchors.fill: parent

                    acceptedButtons: Qt.LeftButton | Qt.RightButton

                    onClicked: {

                        if (mouse.button === Qt.RightButton)
                            return contextMenu.popup()

                        jsonFile.setName(fileHandler.getStandardPath()+"./sets/"+model.name+".json")
                        let readJson = jsonFile.read()
                        let parsed = readJson.data

                        for(var i = 0; i < 40; i++){
                            let e = parsed[i]
                            inventory.setProperty(i, "name", e.name)
                            inventory.setProperty(i, "detail", e.detail)
                            inventory.setProperty(i, "hexstr", e.hexstr)
                            inventory.setProperty(i, "count", e.count)
                            inventory.setProperty(i, "diyid", e.diyid)
                            inventory.setProperty(i, "gridId", e.gridId)
                        }

                        messageDialog2.text = "Successfully loaded item set!"

                        messageDialog2.open()


                    }

                    Menu {
                        id: contextMenu
                        MenuItem { text: "Save to this set"
                            onClicked: {
                                if(ensureSaveable()){
                                    jsonFile.setName(fileHandler.getStandardPath()+"/sets/"+model.name+".json")

                                    jsonFile.write({data: getSetAsJsonOnly()})

                                    messageDialog2.text = "Saved item set!"

                                    messageDialog2.open()

                                    itemSetRegion.refreshItemSets()
                                }else{
                                    messageDialog2.text = "At least 1 item must be preset to save!"

                                    messageDialog2.open()
                                }
                            }
                        }

                        MenuItem { text: "Delete"
                            onClicked: {
                                fileHandler.deleteSet(model.name)
                                itemSetRegion.refreshItemSets()
                            }
                        }
                    }

                }
            }

            Component.onCompleted: {
                itemSetRegion.refreshItemSets()
            }
        }
    }

    Rectangle{
        id: inventoryGrid
        anchors.top: parent.top
        anchors.left: itemSetRegion.right
        anchors.right: itemsBox.left

        width: 800
        height: 400

        GridView {
            id: grid
            interactive: false
            anchors.fill: parent

            cellWidth: width / 10
            cellHeight: height / 4

            model: inventory
            delegate: Component {
                Item {
                    id: main
                    width: grid.cellWidth; height: grid.cellHeight

                    Rectangle {
                        id: item; parent: loc
                        x: main.x + 5; y: main.y + 5
                        width: main.width - 10; height: main.height - 10;

                        color: diyid ? "#ebd534" : "white"

                        Text{
                            anchors.margins: 10
                            anchors.fill: parent
                            text: name + " " + detail
                            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                            font.pixelSize: 10
                        }

                        Text{
                            anchors.right: parent.right
                            anchors.bottom: parent.bottom
                            anchors.rightMargin: 10
                            anchors.bottomMargin: 10
                            text: count
                            font.pixelSize: 12
                        }

                        Rectangle {
                            anchors.fill: parent;
                            border.color: "#326487"; border.width: 2
                            color: "transparent"; radius: 5
                            visible: true
                        }

                        Behavior on x {
                            enabled: item.state != "active"
                            NumberAnimation { duration: 400; easing.type: Easing.OutBack }
                        }

                        Behavior on y {
                            enabled: item.state != "active"
                            NumberAnimation { duration: 400; easing.type: Easing.OutBack }
                        }

                        states: State {
                            name: "active"; when: loc.currentId === gridId
                            PropertyChanges { target: item; x: loc.mouseX - width/2; y: loc.mouseY - height/2; }
                        }

                        transitions: Transition { NumberAnimation { property: "scale"; duration: 50} }
                    } //Image
                } //Item
            } //Component

        }

        MouseArea {
            property int currentId: -1 // Original position in model
            property int newIndex // Current Position in model
            property int index: grid.indexAt(mouseX, mouseY) // Item underneath cursor

            acceptedButtons: Qt.LeftButton | Qt.RightButton

            property var clickStart: new Date().getTime()

            id: loc
            anchors.fill: parent
            onPressAndHold: {
                if(!movementEnabled) return
                let elapsed = new Date().getTime() - clickStart

                if(elapsed > 1000){
                    currentId = inventory.get(newIndex = index).gridId
                }
            }

            onReleased: currentId = -1
            onPositionChanged: {
                if(!movementEnabled) return

                let elapsed = new Date().getTime() - clickStart

                if(elapsed > 1000){
                    if (loc !== currentId && index !== -1 && index !== newIndex)
                        inventory.move(newIndex, newIndex = index, 1)
                }
            }
            onClicked: {
                clickStart = new Date().getTime()

                if(!movementEnabled){
                    if (mouse.button == Qt.RightButton){
                        inventory.setProperty(index, "name", '')
                        inventory.setProperty(index, "detail", '')
                        inventory.setProperty(index, "hexstr", '')
                        inventory.setProperty(index, "diyid", '')
                        inventory.setProperty(index, "count", 0)
                    }else{
                        if(inventory.get(index).diyid){
                            inventory.setProperty(index, "name", selectedItemName)
                            inventory.setProperty(index, "detail", selectedItemDetail)
                            inventory.setProperty(index, "hexstr", selectedItemHexstr)
                            inventory.setProperty(index, "diyid", '')
                            inventory.setProperty(index, "count", selectedItemCount)
                        }else{
                            inventory.setProperty(index, "name", selectedItemName)
                            inventory.setProperty(index, "detail", selectedItemDetail)
                            inventory.setProperty(index, "hexstr", selectedItemHexstr)
                            inventory.setProperty(index, "diyid", selectedItemdiyid)
                            inventory.setProperty(index, "count", selectedItemCount)
                        }
                    }
                }
            }
        }
    }

    Shortcut{
        sequence: "F1"
        onActivated: {
            movementEnabled = !movementEnabled
        }
    }

    Rectangle{
        id: infoPanel

        anchors.left: itemSetRegion.right
        anchors.right: itemsBox.left
        anchors.bottom: parent.bottom
        anchors.top: inventoryGrid.bottom

        color: "#BBBBBB"


        Column{
            anchors.fill: parent
            spacing: 5

            Row {
                spacing: 5
                Text {
                    text: "Currently selected item    "
                    font.pixelSize: 24
                }

                Text {
                    text: movementEnabled ? "Movement Enabled (F1)" : "Movement Disabled (F1)"
                    font.pixelSize: 18
                }

                Button{
                    text: "Fill All"

                    onClicked: {
                        if(selectedItemName === "") return

                        inventory.clear()

                        for(var j = 0; j < 40; j++){
                            inventory.append({
                                                 name: selectedItemName,
                                                 detail: selectedItemDetail,
                                                 hexstr: selectedItemHexstr,
                                                 count: selectedItemCount,
                                                 diyid: selectedItemdiyid,
                                                 gridId: j,
                                             })
                        }
                    }
                }

                Button{
                    text: "Clear All"
                    onClicked: {
                        inventory.clear()

                        for(var j = 0; j < 40; j++){
                            inventory.append({
                                                 name: '',
                                                 detail: '',
                                                 hexstr: '',
                                                 diyid: '',
                                                 count: 0,
                                                 gridId: 0,
                                             })
                        }
                    }
                }
            }

            Row{
                Text {
                    text: qsTr("Name: ")
                    font.pixelSize: 20
                }
                Text {
                    text: selectedItemName
                    font.pixelSize: 20
                }
            }

            Row{
                Text {
                    text: qsTr("Detail: ")
                    font.pixelSize: 20
                }
                Text {
                    text: selectedItemDetail
                    font.pixelSize: 20
                }
            }

            Row{
                Text {
                    text: qsTr("Hex: ")
                    font.pixelSize: 20
                }
                Text {
                    text: selectedItemHexstr
                    font.pixelSize: 20
                }
            }

            Row{
                Text {
                    text: qsTr("Has DIY Recipe: ")
                    font.pixelSize: 20
                }
                Text {
                    text: selectedItemdiyid ? "YES (Click on slot again to toggle DIY or ITEM. When YELLOW it is DIY)" : "NO"
                    font.pixelSize: 20
                }
            }

            Row{
                Text {
                    text: qsTr("Item Count: ")
                    font.pixelSize: 20
                }
                SpinBox{
                    stepSize: 1
                    value: selectedItemCount
                    from: 1
                    to: 30
                    editable: true

                    validator: IntValidator {
                        bottom: 1
                        top: 30
                    }

                    onValueModified: {
                        selectedItemCount = value
                    }



                }

                Button {
                    text: "1"
                    onClicked: {
                        selectedItemCount = 1
                    }
                }

                Button {
                    text: "10"
                    onClicked: {
                        selectedItemCount = 10
                    }
                }

                Button {
                    text: "30"
                    onClicked: {
                        selectedItemCount = 30
                    }
                }
            }




            Row{
                Text {
                    text: qsTr("Verify and Upload: ")
                    font.pixelSize: 20
                }
                Button{
                    text: "Upload to Switch"
                    onClicked: {
                        uploadAllSets()
                    }
                }
            }

            Text {
                id: name
                font.pixelSize: 12
                text: "Search examples:\n To search for purple plants, type purple/plant\nClick the item on the right then click the corresponding inventory slot.\nOnce inventory is populated, ensure\n switch ftp server is ON and click Upload to Switch"
            }


            Row{
                Text {
                    text: qsTr("FTP String: ")
                    font.pixelSize: 20
                }
                TextField {
                    id: ftpField
                    text: settings.ftpString
                    width: 500
                    selectByMouse: true

                    onTextChanged: {
                        ftpString = text
                    }
                }
            }
        }
    }

    Rectangle{
        id: itemsBox
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: 400

        TextField {
            id: textField
            anchors { top: parent.top; left: parent.left; right: parent.right }
            height: implicitHeight
            selectByMouse: true
        }

        SortFilterProxyModel {
            id: personProxyModel
            sourceModel: itemsModel
            filters: AnyOf{
                RegExpFilter {
                    roleName: "name"
                    pattern: textField.text
                    caseSensitivity: Qt.CaseInsensitive

                }

                ExpressionFilter{
                    expression: {
                        var haystack = String(model.name).toLowerCase()
                        var needle1 = String(textField.text).toLowerCase()
                        var needlesplit = needle1.split("/")
                        var needle = needlesplit[0]

                        var hassecond = needlesplit.length > 1

                        if (hassecond) {
                            var first = needlesplit[0]
                            var second = needlesplit[1]
                            return haystack.indexOf(first) !== -1 && haystack.indexOf(second) !== -1
                        } else {
                            return haystack.indexOf(needle1) !== -1
                        }
                    }
                }
            }

            sorters: StringSorter { roleName: "firstName" }
        }

        ListView {
            clip: true
            spacing: 3
            anchors { top: textField.bottom; bottom: parent.bottom; left: parent.left; right: parent.right }
            model: personProxyModel
            delegate: Rectangle{
                color: model.diyid ? "#EBD534" : "#DDDDDD"
                height: 50
                width: parent.width

                Text { anchors.centerIn: parent; text: model.name + " " + (model.color ? model.color : '') +" [" + model.detail + "]"; font.pixelSize: 14}

                MouseArea{
                    anchors.fill: parent

                    onClicked: {
                        selectedItemDetail = model.detail
                        selectedItemHexstr = model.hexstr
                        selectedItemName = model.name
                        selectedItemdiyid = model.diyid
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        jsonFile.setName("./items.json")
        var items = jsonFile.read()

        itemsModel.clear()

        console.log( jsonFile.error)

        let itemCount = 0

        for(var i in items){
            itemCount++
            let item = items[i]
            itemsModel.append(item)
        }

        inventory.clear()

        for(var j = 0; j < 40; j++){
            inventory.append({
                                 name: '',
                                 detail: '',
                                 hexstr: '',
                                 count: 0,
                                 gridId: 0,
                             })
        }

        console.log("Loaded " + itemCount + " items and " + itemOffsets.length + " item offsets")
    }
}

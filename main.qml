import QtQuick 2.5
import QtQuick.Window 2.2

Window {
    visible: true
    width: 640; height: 480

    Rectangle {
        id: root
        anchors.centerIn: parent
        width: 481  // change this to 480 and everything works!
        height: 490

        color: "lightsteelblue"
        radius: 10

        Item {
            id: mapSelector

            x: (root.width-mapSelector.width)/2
            y: 0
            width: root.width/2
            height: root.height

            ListView {
                id: listView
                anchors.fill: parent
                interactive: false
                model: ColorsModel { id: colorsModel }
                delegate: MouseArea {
                    id: delegateRoot
                    property int visualIndex: index

                    width: ListView.view.width
                    height: ListView.view.height/ListView.view.count

                    drag {
                        target: draggableRoot
                        axis: Drag.YAxis
                    }

                    Item {
                        id: draggableRoot
                        anchors {
                            horizontalCenter: parent.horizontalCenter
                            verticalCenter: parent.verticalCenter
                        }
                        width: delegateRoot.width
                        height: delegateRoot.height

                        Drag.active: delegateRoot.drag.active
                        Drag.source: delegateRoot

                        states: [
                            State {
                                when: draggableRoot.Drag.active
                                ParentChange {
                                    target: draggableRoot
                                    parent: listView
                                }
                                AnchorChanges {
                                    target: draggableRoot
                                    anchors.horizontalCenter: undefined
                                    anchors.verticalCenter: undefined
                                }
                            }
                        ]

                        Rectangle {
                            id: mapImage
                            anchors { fill: parent; margins: 2 }
                            color: mapColor
                        }
                    }

                    DropArea {
                        anchors.fill: parent
                        onEntered: {
                            console.log("MOVING " + drag.source.visualIndex + " TO " + delegateRoot.visualIndex);
                            colorsModel.move(drag.source.visualIndex, delegateRoot.visualIndex, 1);
                            console.log("MOVED");
                        }
                    }
                }

                displaced: Transition {
                    NumberAnimation { properties: "x,y"; easing.type: Easing.OutQuad }
                }
            }
        }
    }
}

<%@ Page Title="JQX Grid" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link rel="stylesheet" type="text/css" href="Scripts/jqwidgets/styles/jqx.base.css" />
    <script type="text/javascript" src="Scripts/demos.js"></script>
    <script type="text/javascript" src="Scripts/generatedata.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            var getAdapter = function () {
                // prepare the data
                var data = generatedata(15);

                var source =
                    {
                        localdata: data,
                        datatype: "array",
                        datafields:
                            [
                                { name: 'firstname', type: 'string' },
                                { name: 'lastname', type: 'string' },
                                { name: 'productname', type: 'string' },
                                { name: 'quantity', type: 'number' },
                                { name: 'price', type: 'number' },
                                { name: 'available', type: 'bool' }
                            ],
                        updaterow: function (rowid, rowdata, commit) {
                            // synchronize with the server - send update command
                            // call commit with parameter true if the synchronization with the server is successful
                            // and with parameter false if the synchronization failed.
                            commit(true);
                        }
                    };

                var dataAdapter = new $.jqx.dataAdapter(source);
                return dataAdapter;
            }

            // initialize jqxGrid
            $("#grid").jqxGrid(
                {
                    width: getWidth('Grid'),
                    source: getAdapter(),
                    showtoolbar: true,
                    rendertoolbar: function (statusbar) {
                        // appends buttons to the status bar.
                        var container = $("<div style='overflow: hidden; position: relative; margin-top: 4px;'></div>")
                        var reloadButton = $("<div style='float: left; margin-left: 5px;'><img style='position: relative;' src='images/refresh.png'/></div>");
                        var searchButton = $("<div style='float: left; margin-left: 5px;'><img style='position: relative;' src='images/search.png'/></div>");

                        container.append(reloadButton);
                        container.append(searchButton);
                        statusbar.append(container);

                        reloadButton.jqxButton({ width: 16, height: 16 });
                        searchButton.jqxButton({ width: 16, height: 16 });

                        // reload grid data.
                        reloadButton.click(function (event) {
                            $("#grid").jqxGrid({ source: getAdapter() });
                        });
                        // search for a record.
                        searchButton.click(function (event) {
                            //var offset = $("#grid").offset();
                            var offset = $(searchButton).offset();
                            $("#jqxwindow").jqxWindow('open');
                            $("#jqxwindow").jqxWindow('move', offset.left, offset.top + 30);
                        });
                    },
                    columns: [
                        { text: 'First Name', columntype: 'textbox', datafield: 'firstname', width: 120 },
                        { text: 'Last Name', datafield: 'lastname', columntype: 'textbox', width: 120 },
                        { text: 'Product', datafield: 'productname', width: 170 },
                        { text: 'In Stock', datafield: 'available', columntype: 'checkbox', width: 125 },
                        { text: 'Quantity', datafield: 'quantity', width: 85, cellsalign: 'right', cellsformat: 'n2' },
                        { text: 'Price', datafield: 'price', cellsalign: 'right', cellsformat: 'c2' }
                    ]
                });

            // create jqxWindow.
            $("#jqxwindow").jqxWindow({ resizable: false, autoOpen: false, width: 210, height: 195 });
            // create find and clear buttons.
            $("#findButton").jqxButton({ width: 70, height: 16 });

            // create dropdownlist.
            $("#dropdownlist").jqxDropDownList({
                autoDropDownHeight: true, selectedIndex: 0, width: 198, height: 30,
                source: [
                    'First Name', 'Last Name', 'Product', 'Quantity', 'Price'
                ]
            });

            if (theme != "") {
                $("#inputField").addClass('jqx-input-' + theme);
            }

            // find records that match a criteria.
            $("#findButton").click(function () {
                $("#grid").jqxGrid('clearfilters');
                var searchColumnIndex = $("#dropdownlist").jqxDropDownList('selectedIndex');
                var datafield = "";
                switch (searchColumnIndex) {
                    case 0:
                        datafield = "firstname";
                        break;
                    case 1:
                        datafield = "lastname";
                        break;
                    case 2:
                        datafield = "productname";
                        break;
                    case 3:
                        datafield = "quantity";
                        break;
                    case 4:
                        datafield = "price";
                        break;
                }

                var searchText = $("#inputField").val();
                $("#jqxwindow").jqxWindow('close');
                alert('Buscar: ' + searchText + ' en ' + datafield);
            });
        });
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="Server">
    <h1>JQX Grid</h1>
    <div id='jqxWidget'>
        <div id="grid"></div>

        <%-- search window  --%>
        <div id="jqxwindow">
            <div>Find Record</div>
            <div style="overflow: hidden;">
                <div>Find what:</div>
                <div style='margin-top: 5px;'>
                    <input id='inputField' type="text" class="jqx-input" style="width: 190px; height: 23px; border-radius: 5px" />
                </div>
                <div style="margin-top: 7px; clear: both;">Look in:</div>
                <div style='margin-top: 5px;'>
                    <div id='dropdownlist'></div>
                </div>
                <div style='margin-top: 10px; margin-right: 5px; float: right;' id="findButton">Search</div>
            </div>
        </div>
    </div>
</asp:Content>


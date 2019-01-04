function Catalogo(xGrid, icon) {
    var self = this;
    var oldPage = 0;
    var pageSize = 25;

    xGrid.unbind();

    var source = {
        localdata: [],
        datatype: "json",
        datafields: [],
        updaterow: function (rowid, rowdata, commit) { commit(true); }
    };

    var dataAdapter = new $.jqx.dataAdapter(source);

    xGrid.jqxGrid({
        width: '98.5%',
        height: '100%',
        theme: 'energyblue',
        scrollmode: 'deferred',
        source: dataAdapter,
        pageable: true,
        pagesizeoptions: ['25', '100', '250'],
        pageSize: 25,
        sortable: false,
        altrows: true,
        enabletooltips: false,
        editable: false,
        showfilterrow: false,
        filterable: true,
        columnsreorder: false,
        columnsresize: false,
        autoshowfiltericon: false,
        columns: [],
        //virtualmode: true,
        //rendergridrows: renderGridRows,
        showtoolbar: true,
        rendertoolbar: renderToolbar
    });

    this.initialize = function (localdata, columns, pageSizeOptions) {
        source.datafields = [];
        columns.forEach(function (e) { source.datafields.push({ name: e.datafield, type: e.type }); });
        source.localdata = localdata;
        source.totalrecords = 7000;
        //source.pagenum = 5;

        dataAdapter = new $.jqx.dataAdapter(source);

        if (pageSizeOptions)
            xGrid.jqxGrid({ source: dataAdapter, columns: columns, pagesizeoptions: pageSizeOptions, pageSize: parseInt(pageSizeOptions[0]), virtualmode: true, rendergridrows: renderGridRows });
        else
            xGrid.jqxGrid({ source: dataAdapter, columns: columns });
    }

    // default event
    xGrid.bind('pagesizechanged', function (event) {
        pageSize = event.args.pagesize;
        if (self.onPageSizeChangedEvent) self.onPageSizeChangedEvent(self, event);
    });

    xGrid.bind('pagechanged', function (event) {
        event.self = self;
        event.args.prevpage = oldPage;
        oldPage = event.args.pagenum;

        if (self.onPageChangedEvent) self.onPageChangedEvent(self, event);
    });

    xGrid.bind('rowdoubleclick', function (event) { if (self.onRowDoubleClick) self.onRowDoubleClick(self, event); });
    xGrid.bind('rowclick', function (event) { if (self.onRowClickEvent) self.onRowClickEvent(self, event); });


    // Object events
    this.onPageChanged = function (callback) { self.onPageChangedEvent = callback; }
    this.onPageSizeChanged = function (callback) { self.onPageSizeChangedEvent = callback; }
    this.onRowClick = function (callback) { self.onRowClickEvent = callback; }
    this.onRowDoubleClick = function (callback) { self.onRowDoubleClickEvent = callback; }

    // toolbar events
    this.onSearch = function (callback) { self.onSearchEvent = callback; }
    this.onReload = function (callback) { self.onReloadEvent = callback; }

    this.resetAdapter = function (data) {
        source.localdata = data;
        xGrid.jqxGrid({ source: new $.jqx.dataAdapter(source) });
    }

    this.clearGrid = function () { xGrid.jqxGrid('clear'); }
    this.updateBoundData = function () { xGrid.jqxGrid('updatebounddata', 'cells'); }

    this.getSource = function () { return source; }
    this.setLocalData = function (localData) { source.localdata = localData; }
    this.getCellValue = function (row, col) { return xGrid.jqxGrid('getcellvalue', row, dataFields[col].name); }
    this.getPageSize = function () { return pageSize; }

    // create toolbar
    function renderToolbar(statusbar) {
        $(statusbar).empty();
        var container = $("<div style='overflow: hidden; position: relative; margin-top: 4px; float: right; margin-right: 5px;'></div>")
        var searchInput = $("<input id='input' style='float: left; margin-left: 5px;'/>");
        var searchButton = $("<div style='float: left; margin-left: 5px;'><img style='position: relative;' src='" + icon + "'/></div>");
        container.append(searchInput);
        container.append(searchButton);
        statusbar.append(container);

        // button styles
        searchInput.jqxInput({ width: 250, height: 22, placeHolder: " search", theme: 'energyblue' });
        searchButton.jqxButton({ width: 16, height: 16, theme: 'energyblue' });

        var search = function (event) {
            if (self.onSearchEvent) self.onSearchEvent(self, searchInput.val());
            searchInput.val('');
        }

        // events
        $(searchInput).keyup(function (e) { if (e.keyCode == 13) search(e); });
        searchButton.click(search);

        console.log('renderToolbar');
    }

    function renderGridRows(params) {
        console.log('rendergridrows L: ' + source.localdata.length + ' -> ' + params.startindex + ' , ' + params.endindex);

        $.ajax({
            type: 'POST',
            url: 'Default.aspx/GetJson',
            data: JSON.stringify({ 'page': 0, 'pageSize': 25 }),
            contentType: 'application/json; charset=utf-8',
            dataType: 'json',
            success: function (response) {
                var json = JSON.parse(response.d);
                json.data.forEach(function (a) { source.localdata[27] = a; });
            },
            error: function (xhr, ajaxOptions, thrownError) {
                alert('No se ha podido obtener la información');
            }
        });

        return source.localdata;
    }
}
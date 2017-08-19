<%@ Assembly Name="$SharePoint.Project.AssemblyFullName$" %>
<%@ Assembly Name="Microsoft.Web.CommandUI, Version=14.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %> 
<%@ Register Tagprefix="SharePoint" Namespace="Microsoft.SharePoint.WebControls" Assembly="Microsoft.SharePoint, Version=14.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %> 
<%@ Register Tagprefix="Utilities" Namespace="Microsoft.SharePoint.Utilities" Assembly="Microsoft.SharePoint, Version=14.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<%@ Register Tagprefix="asp" Namespace="System.Web.UI" Assembly="System.Web.Extensions, Version=3.5.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" %>
<%@ Import Namespace="Microsoft.SharePoint" %> 
<%@ Register Tagprefix="WebPartPages" Namespace="Microsoft.SharePoint.WebPartPages" Assembly="Microsoft.SharePoint, Version=14.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="SFilterWP.ascx.cs" Inherits="SandFilter.SFilterWP.SFilterWP" %>
<% if (false)
   { %>
<script type="text/javascript" src="/_layouts/MicrosoftAjax.js" ></script>
<script type="text/javascript" src="/_layouts/SP.debug.js" ></script>
<script type="text/javascript" src="/_layouts/1033/init.debug.js" ></script>
<% } %>
<!-- Start of MY application -->
<!-- Remove the '..' part when dragged from Solution Explorer. -->
<link href="/Content/themes/base/all.css" rel="stylesheet" />
<link href="/Content/themes/redmond/jquery-ui.redmond.min.css" rel="stylesheet" />
<script type="text/javascript">
    //console.log('START jQuery version: ' + $.fn.jquery);
    var jQLoaded
    if (window.jQuery) {
        jQLoaded = $.noConflict(true); //Deconflict jquery versions if already loaded.
    }     
</script>
<!-- Remove the '..' part when dragged from Solution Explorer for it to reference properly. -->
<script type="text/javascript" src="/Scripts/jquery-1.6.4.min.js"></script>
<script type="text/javascript" src="/Scripts/jquery-ui.min-1.11.1.js"></script>
<script type="text/javascript" src="/Scripts/camljs.js"></script>
<script type="text/javascript">
    //console.log('REPLACED jQuery version: ' + $.fn.jquery + '; jQueryUI version: ' + $.ui.version);
</script>
<style type="text/css">
    .auto-style-container {
        width: 4px;        
    } 
    .overflow { height: 300px; }           
</style>
<style class="ui-selectmenu-optgroup">
  .ui-autocomplete {
    max-height: 700px;
    overflow-y: auto;
    /* prevent horizontal scrollbar */
    overflow-x: hidden;
  }
  /* IE 6 doesn't support max-height
   * we use height instead, but this forces the menu to always be this tall
   */
  * html .ui-autocomplete {
    height: 700px;
  }
  /*Configure jQuery UI select menu button height*/
  .ui-selectmenu-button {
      max-height: 20px;                 
  }
  /*jQuery UI Widget font adjust*/
  .ui-widget {
      font: inherit;
      font-size: 11px;      
  } 
  .ui-textfield {
      height: 18px;
      font: inherit;
      font-size: 12px;                      
  } 
  /*Align command buttons*/
  .ui-button {
      height: 20px;
      width: 29px;
      margin-left: 1px;
      margin-top: 1px;
      margin-bottom: 3px;        
  }
  /*Align datepicker trigger button*/
  .ui-datepicker-trigger {
      margin-left: 1px;
      margin-top: 1px;
      margin-bottom: 3px;
  } 
  /*Align labels*/
  label {
    float: left;
    width: auto;
    margin-top: 3px;
  }  
</style>
<table id="TableSandFilter" hidden="hidden">
    <tr>        
        <td>
            <div id="DivListFields">
                <label for="DdlListFields" title="Select a field">
                    Field: </label><asp:DropDownList ID="DdlListFields" runat="server" onchange="DdlListFields_OnChange(this)" data-native-menu="true">
                    <asp:ListItem></asp:ListItem>
                </asp:DropDownList>
            </div>
        </td>
        <td>
        </td>
        <td>
            <div id="DivLogicalPerator">
                <label for="DdlLogicalOperator" title="Select a logic operator">
                    Logic: </label>
                <asp:DropDownList ID="DdlLogicalOperator" runat="server" onchange="DdlLogicalOperator_OnChange(this)" data-native-menu="true">
                    <asp:ListItem></asp:ListItem>
                    <asp:ListItem Value="and">And</asp:ListItem>
                    <asp:ListItem Value="or">Or</asp:ListItem>
                </asp:DropDownList>
            </div>
        </td>
        <td>
        </td>
        <td>
            <div id="DivComparisonOperator">
                <label for="DdlComparisonOperator">
                    Operator: </label>
                <asp:DropDownList ID="DdlComparisonOperator" runat="server" onchange="DdlComparisonOperator_OnChange(this)" title="Comparison operator" data-native-menu="true">
                    <asp:ListItem></asp:ListItem>
                    <asp:ListItem Value="beginswith">Begins With</asp:ListItem>
                    <asp:ListItem Value="contains">Contains</asp:ListItem>                    
                    <asp:ListItem Value="daterange">Date Range</asp:ListItem>
                    <asp:ListItem Value="daterangesoverlap">Date Ranges Overlap</asp:ListItem>    
                    <asp:ListItem Value="eq">Equal</asp:ListItem>
                    <asp:ListItem Value="gt">Greater Than</asp:ListItem>
                    <asp:ListItem Value="geq">Greater Than or Equal</asp:ListItem>
                    <asp:ListItem Value="lt">Less Than</asp:ListItem>
                    <asp:ListItem Value="leq">Less Than or Equal</asp:ListItem>
                </asp:DropDownList>
            </div>            
        </td>
        <td>
        </td>
        <td>
            <div class="ui-front">
                <label for="TbSearchText" id="lblTbSearchText" title="Type a value for auto-complete">
                    Value:
                </label>
                <asp:TextBox ID="TbSearchText" runat="server" Width="140px" MaxLength="1000" Enabled="False"></asp:TextBox>
            </div>
        </td>
        <td>
            <div id="DivTextSearchToDate" hidden="hidden" class="ui-front">
                <label for="TextSearchToDate", id="lblTextSearchToDate" title="Type a second value for auto-complete">
                    To:
                </label>
                <asp:TextBox ID="TextSearchToDate" runat="server" Width="140px" MaxLength="1000" Enabled="False"></asp:TextBox>
            </div>
        </td>
        <td>
            <div style="text-align: center">
                <button type="button" id="ButtonClientSideSearch" title="Search with filter" value="Search"></button><button type="button" id="ButtonClientSideClear" title="Clear filter" value="Clear"></button></div>
        </td>
    </tr>
    </table>

<script type="text/javascript">
    $(document).ready(function () {       

        SP.SOD.executeOrDelayUntilScriptLoaded(getViewById, 'sp.js');        

        var ids = getIds();
        ProcessFieldTypeChange(ids);
        
        $('#' + ids.clIdDdlListFields).selectmenu({
            open: function (event, ui) {
                $('li.ui-menu-item').tooltip({
                    items: 'li',
                    content: function () {
                        var tTip = ($(this).html().replace(/&nbsp;/g, ''));
                        return tTip;
                    }
                });
            },
            change: function ( event, ui ) {
                DdlListFields_OnChange(this);
            },
            appendTo: '#' + ids.clIdDivListFields,
            width: 'auto'
        }).selectmenu('menuWidget').addClass('overflow');
        $('#' + ids.clIdDdlListFields + '-button').attr('title', 'Select a field');

        $('#' + ids.clIdDdlLogicalOperator).selectmenu({            
            open: function (event, ui) {
                $('li.ui-menu-item').tooltip({
                    items: 'li',
                    content: function () {
                        var tTip = ($(this).html().replace(/&nbsp;/g, ''));
                        return tTip;
                    }
                });
            },
            change: function (event, ui) {
                DdlLogicalOperator_OnChange(this);
            },
            appendTo: '#' + ids.clIdDivLogicalPerator,
            width: 'auto'
        }).selectmenu('menuWidget');
        $('#' + ids.clIdDdlLogicalOperator + '-button').attr('title', 'Select a logic operator');

        $('#' + ids.clIdDdlComparisonOperator).selectmenu({
            open: function (event, ui) {
                $('li.ui-menu-item').tooltip({
                    items: 'li',
                    content: function () {
                        var tTip = ($(this).html().replace(/&nbsp;/g, ''));
                        return tTip;
                    }
                });
            },
            change: function (event, ui) {
                DdlComparisonOperator_OnChange(this);
            },
            appendTo: '#' + ids.clIdDivComparisonOperator,
            width: 'auto'
        }).selectmenu('menuWidget');
        $('#' + ids.clIdDdlComparisonOperator + '-button').attr('title', 'Select a comparison operator');

        $('#' + ids.clIdTbSearchText).addClass('ui-textfield ui-widget-content'); //ui-widget ui-widget-content ui-corner-all 
        $('#' + ids.clIdTextSearchToDate).addClass('ui-textfield ui-widget-content');                       

        $('#' + ids.clIdTextSearchToDate).keyup(function () {
            OnFilterChange(ids);
        });

        $('#' + ids.clIdTbSearchText).mouseup(function () {
            OnClearTextButtonPressed(this);
        });

        $('#' + ids.clIdTextSearchToDate).mouseup(function () {
            OnClearTextButtonPressed(this);
        });
                 
        $('#' + ids.clIdButtonClientSideSearch).button({
            icons: {
                primary: "ui-icon-search"
            }
        }).click(function () {
            OnSerchQuery(ids);
        });

        $('#' + ids.clIdButtonClientSideClear).button({
            icons: {
                primary: "ui-icon-close"
            }
        }).click(function () {            
            $('#' + ids.clIdHidJsonObject).val('');
            $('#' + ids.clIdHidCamlQuery).val('');
            ClearCurrentView(ids);
            ClearControlValuesOnChange(ids);
            ClearDdlListFields(ids);              
        });

        function OnClearTextButtonPressed(ctrl) {
            var $input = $(ctrl);
            var oldValue = $input.val();
            if (oldValue == '') return;
            // When this event is fired after clicking on the clear button, the value is not cleared yet. We have to wait for it.
            setTimeout(function () {
                var newValue = $input.val();
                if (newValue == '') {
                    var keyupEvent = $.Event('keyup'); // Trigger the keyup event to run OnFilterChange(ids)...
                    $input.trigger(keyupEvent);
                    RemoveNotification(); //Remove notification if still running.
                    $('#' + ctrl.id).autocomplete('close');
                }
            }, 1);
        }

        ExecuteOrDelayUntilBodyLoaded(delayShowAfterBody);
        function delayShowAfterBody() {
            $('#' + 'TableSandFilter').show();            
        }

        SP.SOD.executeOrDelayUntilScriptLoaded(loadPreviousQuery, 'sp.js');

    });  

    function loadPreviousQuery() {
        var ids = getIds();
        var previousQuery = $('#' + ids.clIdHidJsonObject).val();
        if (previousQuery) {
            OnFilterChange(ids);
        }
        ProcessDataViewOnLoad(ids);
    }

    function ClearDdlListFields(ids) {
        $('#' + ids.clIdDdlListFields).val('');
        $('#' + ids.clIdDdlListFields).text('');        
    }

    //function getListName() {
    //    var listId = _spPageContextInfo.pageListId;
    //    var ctx = SP.ClientContext.get_current();
    //    this.list = ctx.get_web().get_lists().getById(listId);
    //    ctx.load(this.list);
    //    ctx.executeQueryAsync(Function.createDelegate(this, this.onSuccessLoadList), Function.createDelegate(this, this.onFail));        
    //}   

    function getViewById() {
        var listId = _spPageContextInfo.pageListId;
        var viewId;
        for (var ctxKey in g_ctxDict) {
            var curCtx = g_ctxDict[ctxKey];
            if (curCtx.listName.toString().toLowerCase() == listId.toString().toLowerCase()) {
                viewId = curCtx.view;
                break;
            }
        }
        getListView(listId, viewId);       
    }   

    function getListView(listId, viewId) {
        var ctx = SP.ClientContext.get_current();
        this.list = ctx.get_web().get_lists().getById(listId);
        ctx.load(this.list);
        ctx.executeQueryAsync(Function.createDelegate(this, this.onSuccessLoadList), Function.createDelegate(this, this.onFail));
        this.view = list.get_views().getById(viewId);        
        ctx.load(this.view);
        ctx.executeQueryAsync(Function.createDelegate(this, this.onSuccessLoadView), Function.createDelegate(this, this.onFail));
    }

    function onSuccessLoadList(sender, args) {
        var listName = this.list.get_title();
        $('#' + '<%= HidSPListName.ClientID %>').val(listName);         
        $('#' + '<%= TbSearchText.ClientID %>').prop('disabled', false); 
        $('#' + '<%= TextSearchToDate.ClientID %>').prop('disabled', false); 
    }

    function onSuccessLoadView(sender, args) {
        var viewName = this.view.get_title();
        var viewId = this.view.get_id();        
        $('#' + '<%= HidSPViewName.ClientID %>').val(viewName); //Set hidden field to be used on server side.
        $('#' + '<%= HidCurrentViewID.ClientID %>').val(viewId); //Set hidden for current view Id.
    }

    function onFail(sender, args) {
        alert(args.get_message());
    }            

    function getIds() {
        var ids = {
            clIdDdlListFields: '<%= DdlListFields.ClientID %>',
            clIdDdlComparisonOperator: '<%= DdlComparisonOperator.ClientID %>',
            clIdlblTbSearchText: 'lblTbSearchText',
            clIdTbSearchText: '<%= TbSearchText.ClientID %>',
            clIdDivTextSearchToDate: 'DivTextSearchToDate',
            clIdDivAppMessageError: 'AppMessageError',
            clIdTextSearchToDate: '<%= TextSearchToDate.ClientID %>',
            clIdDivListFields: 'DivListFields',
            clIdDivLogicalPerator: 'DivLogicalPerator',
            clIdDivComparisonOperator: 'DivComparisonOperator',
            clIdDdlLogicalOperator: '<%= DdlLogicalOperator.ClientID %>',
            clIdHidJsonObject: '<%= HidJsonObject.ClientID %>',
            clIdHidSPListName: '<%= HidSPListName.ClientID %>',
            clIdHidSPViewName: '<%= HidSPViewName.ClientID %>',
            clIdHidSiteRestUrl: '<%= HidSiteRestUrl.ClientID %>',
            clIdHidCamlQuery: '<%= HidCamlQuery.ClientID %>',                        
            clIdHidCurrentViewID: '<%= HidCurrentViewID.ClientID %>',
            clIdButtonClientSideSearch: 'ButtonClientSideSearch',
            clIdButtonClientSideClear: 'ButtonClientSideClear',
            clIdTblTableSandFilter: 'TableSandFilter'
        }
        return ids;
    }

    function OnSerchQuery(ids) {
        var query = BuildCamlJsQuery(ids);
        if (query) {
            $('#' + ids.clIdHidCamlQuery).val(query); // Update CAML Query value.
            UpdateCurrentView(ids, query);
        }
    }

    function OnFilterChange(ids) {
        ProcessFilterStatusChange(ids);
        ClearEmptyFilterValues(ids);
    }

    function initJsonObject(ids, fieldValue) {
        var array = [];
        var logicalOperator = $('#' + ids.clIdDdlLogicalOperator).val();
        var comparisonOperator = $('#' + ids.clIdDdlComparisonOperator).val();

        var spField = new SelectedSPField(ids);
        var fieldName = spField.fieldName;
        var fieldType = spField.fieldType;

        array.push(new JsonObjectElement(logicalOperator, comparisonOperator, fieldName, fieldType, fieldValue));
        var jsonString = JSON.stringify(array);
        $('#' + ids.clIdHidJsonObject).val(jsonString);
        return jsonString;
    }

    function ProcessJsonObjectField(ids, fieldValue) {
        var spField = new SelectedSPField(ids);
        var fieldName = spField.fieldName;
        var fieldType = spField.fieldType;
        var logicalOperator = $('#' + ids.clIdDdlLogicalOperator).val();
        var comparisonOperator = $('#' + ids.clIdDdlComparisonOperator).val();

        var oldJsonString = $('#' + ids.clIdHidJsonObject).val();
        var array = JSON.parse(oldJsonString);

        var result = $.grep(array, function (e) { return e.fieldName === fieldName }); // Check if the item is already in array
        if (result.length == 0) { //not found                    
            array.push(new JsonObjectElement(logicalOperator, comparisonOperator, fieldName, fieldType, fieldValue));
            var newJsonString = JSON.stringify(array);
            $('#' + ids.clIdHidJsonObject).val(newJsonString);
            return newJsonString;
        } else { //Item found.  Update the data.
            result[0].logicalOperator = logicalOperator;
            result[0].comparisonOperator = comparisonOperator;
            result[0].fieldType = fieldType;
            result[0].fieldValue = fieldValue;

            var newJsonString = JSON.stringify(array);
            $('#' + ids.clIdHidJsonObject).val(newJsonString);
            return newJsonString;
        }
    }

    function LoadFieldsFromJsonObject(ids) {
        var oldJsonString = $('#' + ids.clIdHidJsonObject).val();
        if (!oldJsonString) return false;

        var spField = new SelectedSPField(ids);
        var fieldName = spField.fieldName;
        var array = JSON.parse(oldJsonString);
        var result = $.grep(array, function (e) { return e.fieldName === fieldName }); // Check if the item is already in array
        if (result.length == 0) { //not found            
            return false;
        } else { //Item found.  Update the data.           
            var logicalOperator = result[0].logicalOperator;
            var comparisonOperator = result[0].comparisonOperator;
            var fieldType = result[0].fieldType;
            var fieldValue = result[0].fieldValue;
            var cmpOpt = comparisonOperator;
            if (cmpOpt === 'daterange' || cmpOpt === 'daterangesoverlap') {
                var ranges = fieldValue.split(';');
                $('#' + ids.clIdTbSearchText).val(ranges[0]);
                $('#' + ids.clIdTextSearchToDate).val(ranges[1]);
            } else {
                $('#' + ids.clIdTbSearchText).val(fieldValue);
            }
            $('#' + ids.clIdDdlLogicalOperator).val(logicalOperator);
            $('#' + ids.clIdDdlComparisonOperator).val(comparisonOperator);
            return true;
        }
    }

    function removeNullEmptyFromArray(arr) {
        var inVal = $.grep(arr, function (n, i) {
            return (n !== '' && n != null);
        });
        return inVal;
    }

    function formatFilterStatusMessage(ids) {
        var spField = new SelectedSPField(ids);
        var fieldType = spField.fieldType;
        var fieldValue = $('#' + ids.clIdTbSearchText).val();
        var cmpOpt = $('#' + ids.clIdDdlComparisonOperator).val(); //Get the value of the comparison operator.        
        if (fieldType === 'DateTime') {
            if (cmpOpt === 'daterange' || cmpOpt === 'daterangesoverlap') {
                fieldValue = fieldValue + ';' + $('#' + ids.clIdTextSearchToDate).val(); // Get the From and To Date range values.
                var jsonString = processComponentJsonObject(ids, fieldValue);
                return jsonString;
            } else if (cmpOpt === '' || cmpOpt === 'eq' || cmpOpt === 'gt' || cmpOpt === 'geq' || cmpOpt === 'lt' || cmpOpt === 'leq') {
                var jsonString = processComponentJsonObject(ids, fieldValue);
                return jsonString;
            } else {
                //TODO: Add Default clause.
                return 'TODO...';
            }
        } else {
            var jsonString = processComponentJsonObject(ids, fieldValue);
            return jsonString;
        }
    }

    function ProcessFilterStatusChange(ids) {
        RemoveAllStatus();        
        var message = formatFilterStatusMessage(ids); //Add values to the hidden field as they are selected.
        UpdateStatus('Filter: ' + message, 'blue');
    }

    function processComponentJsonObject(ids, fieldValue) {
        var oldJsonString = $('#' + ids.clIdHidJsonObject).val();
        if (oldJsonString === '') {
            var jsonString = initJsonObject(ids, fieldValue);
            return jsonString;
        } else {
            var jsonString = ProcessJsonObjectField(ids, fieldValue);
            return jsonString;
        }
    }

    var JsonObjectElement = function (logicalOperator, comparisonOperator, fieldName, fieldType, fieldValue) {
        this.fieldName = fieldName; // Like Title
        this.fieldType = fieldType; // Like Text
        this.logicalOperator = logicalOperator;//  { get; set; }like <Or>, <And>
        this.comparisonOperator = comparisonOperator; // like <Eq>, <Contains>
        this.fieldValue = fieldValue;// some value
    };

    var SelectedSPField = function (ids) {
        var sVal = $('#' + ids.clIdDdlListFields).children('option').filter(':selected').val();
        var sText = $('#' + ids.clIdDdlListFields).children('option').filter(':selected').text();
        if (sVal) {
            if (sVal.indexOf(';') > -1) {
                var spListFieldAndTypeArray = sVal.split(';');
                this.fieldName = spListFieldAndTypeArray[0];
                this.fieldType = spListFieldAndTypeArray[1];
                //Convert field name to proper pascal case: http://stackoverflow.com/questions/196972/convert-string-to-title-case-with-javascript
                var fieldText = toRestFieldCase(sText);
                /*
                Preserve casing, remove spaces and keep the first letter of each individual word as Capital. For example a field with display name "home aDdress" will be "HomeADdress".
                If a special character like dot is in field name or List name it is to be treated like space i.e. if field name is "Add.ress" the REST equivalent will be "AddRess"
                Source: http://www.sharepointnadeem.com/2012/06/field-names-in-rest-query-are-case.html
                */

                /*
                In the regex, the carrot(^) negates the match, so if the stringToReplace contains something that is not a-z or 0-9 it will be replaced
                In this case the desired string will only be alpha numeric characters, stripping out spaces and symbols
                Help from: http://stackoverflow.com/questions/4374822/javascript-regexp-remove-all-special-characters
                */
                var rExp = new RegExp(/[^a-zA-Z0-9]/gi);//White-list letters and numbers.
                if (fieldText === 'ID') {                    
                    this.fieldNameRestFormat = toRestFieldTitleCase(fieldText); //Special case for ID.  REST version uses 'Id' instead of 'ID'.
                } else if (rExp.test(fieldText)) {//If RegEx="/[^a-zA-Z0-9]/gi" evaluates to true process for special characters.
                    var restVal;
                    var inVal = fieldText.split(rExp);//If the regex expression RegEx="/[^a-zA-Z0-9]/gi" contains special characters, split on special character and upper-case the returned values.  For example 'Non-itemized & Costs' should return 'NonItemizedCosts'
                    $.each(inVal, function (index, element) {
                        inVal[index] = toRestFieldCase(inVal[index]);
                    });
                    var restVal = inVal.join('');
                    this.fieldNameRestFormat = restVal;
                } else {
                    var restVal = fieldText.replace(rExp, ''); //If the regex expression RegEx="/[^a-zA-Z0-9]/gi" contains any special characters, remove them.
                    this.fieldNameRestFormat = restVal;
                }                
            }
        }             
    }

    function toRestFieldCase(str) {
        return str.replace(/\w\S*/g, function (txt) { return txt.charAt(0).toUpperCase() + txt.substr(1); });
    }

    function toRestFieldTitleCase(str) {
        return str.replace(/\w\S*/g, function (txt) { return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase(); });
    }

    function getQuerystring(key, default_) {
        if (default_ == null) default_ = '';
        key = key.replace(/[\[]/, '\\\[').replace(/[\]]/, '\\\]');
        var regex = new RegExp('[\\?&]' + key + '=([^&#]*)');
        var qs = regex.exec(window.location.href);
        if (qs == null)
            return default_;
        else
            return qs[1];
    }
</script>

<script type="text/javascript" id="lblMessage">
    function DdlListFields_OnChange(ddl) {
        var ids = getIds();
        var isEdit = LoadFieldsFromJsonObject(ids);
        if (!isEdit) {
            ClearControlValuesOnChange(ids);
            ProcessFieldTypeChange(ids);
            OnFilterChange(ids);
        } else {
            ProcessFieldTypeChange(ids);
        }        
    }

    function DdlLogicalOperator_OnChange(ddl) {
        var ids = getIds();
        OnFilterChange(ids);
    }

    function DdlComparisonOperator_OnChange(ddl) {
        var ids = getIds();
        ProcessComparisonOperatorChange(ids);
        OnFilterChange(ids);        
    }

    function ClearControlValuesOnChange(ids) {
        $('#' + ids.clIdDdlLogicalOperator).val('');
        $('#' + ids.clIdDdlLogicalOperator).selectmenu('refresh');
        $('#' + ids.clIdDdlComparisonOperator).val('');
        $('#' + ids.clIdDdlComparisonOperator).selectmenu('refresh');
        $('#' + ids.clIdTbSearchText).val(''); //Clear the value on the textbox when changed.
        $('#' + ids.clIdTextSearchToDate).val(''); //Clear the DateTo field.
    }

    function ProcessDataViewOnLoad(ids) {
        var url = getCurrentListRestUrl();
        $('#' + ids.clIdHidSiteRestUrl).val(url); // Set the list name value.        
    }

    function ProcessFieldTypeChange(ids) {        
        var spFldObj = new SelectedSPField(ids);
        var field = spFldObj.fieldNameRestFormat;
        var fieldType = spFldObj.fieldType;  
       
        if (fieldType === 'DateTime') {
            ProcessConditionalDateTimeSearchFields(ids, field, fieldType);
            var optionDateTime = ['daterange', 'daterangesoverlap', 'eq', 'gt', 'geq', 'lt', 'leq'];
            EnableSelectOptionsByFieldType(ids, optionDateTime);
        } else if (fieldType === 'Text' || fieldType === 'Computed' || fieldType === 'Note' || fieldType === 'Choice' || fieldType === 'User' || fieldType === 'UserMulti' || fieldType === 'Lookup') {
            ProcessConditionalOtherSearchFields(ids, field, fieldType);
            var optionText = ['eq', 'contains', 'beginswith'];
            EnableSelectOptionsByFieldType(ids, optionText);
        } else if (fieldType === 'Number' || fieldType === 'Counter' || fieldType === 'Currency') {
            ProcessConditionalOtherSearchFields(ids, field, fieldType);
            var optionNumber = ['eq', 'gt', 'geq', 'lt', 'leq'];
            EnableSelectOptionsByFieldType(ids, optionNumber);
        } else {
            ProcessConditionalOtherSearchFields(ids, field, fieldType);
            EnableSelectOptionsByFieldType(ids);
        }
    }

    function ProcessComparisonOperatorChange(ids) {
        var spFldObj = new SelectedSPField(ids);
        var field = spFldObj.fieldNameRestFormat;
        var fieldType = spFldObj.fieldType; 
        
        if (fieldType === 'DateTime') {
            ProcessConditionalDateTimeSearchFields(ids, field, fieldType);
            var optionDateTime = ['daterange', 'daterangesoverlap', 'eq', 'gt', 'geq', 'lt', 'leq'];
            EnableSelectOptionsByFieldType(ids, optionDateTime);
        } else if (fieldType === 'Text' || fieldType === 'Computed' || fieldType === 'Note' || fieldType === 'Choice' || fieldType === 'User' || fieldType === 'UserMulti' || fieldType === 'Lookup') {
            ProcessConditionalOtherSearchFields(ids, field, fieldType);
            var optionText = ['eq', 'contains', 'beginswith'];
            EnableSelectOptionsByFieldType(ids, optionText);
        } else if (fieldType === 'Number' || fieldType === 'Counter' || fieldType === 'Currency') {
            ProcessConditionalOtherSearchFields(ids, field, fieldType);
            var optionNumber = ['eq', 'gt', 'geq', 'lt', 'leq'];
            EnableSelectOptionsByFieldType(ids, optionNumber);
        } else {
            ProcessConditionalOtherSearchFields(ids, field, fieldType);
            EnableSelectOptionsByFieldType(ids);
        }
    }

    function EnableSelectOptionsByFieldType(ids, options) {
        $(function () {
            if (options) {
                $('#' + ids.clIdDdlComparisonOperator).find('option').each(function () {
                    var cmpOpt = $(this).val();
                    if ($.inArray(cmpOpt, options) !== -1 || cmpOpt === '') {
                        $('#' + ids.clIdDdlComparisonOperator + " option[value='" + cmpOpt + "']").attr('disabled', false);
                    } else {
                        $('#' + ids.clIdDdlComparisonOperator + " option[value='" + cmpOpt + "']").attr('disabled', true);
                    }
                });
                $('#' + ids.clIdDdlComparisonOperator).selectmenu("refresh");
            } else { // If no options is passed, disable all.
                $('#' + ids.clIdDdlComparisonOperator).find('option').each(function () {
                    var cmpOpt = $(this).val();
                    $('#' + ids.clIdDdlComparisonOperator + " option[value='" + cmpOpt + "']").attr('disabled', true);
                });
                $('#' + ids.clIdDdlComparisonOperator).selectmenu("refresh");
            }
        });           
    }

    function ClearEmptyFilterValues(ids) {
        var oldJsonString = $('#' + ids.clIdHidJsonObject).val();
        if (oldJsonString) {
            var array = JSON.parse(oldJsonString);
            var result = $.grep(array, function (e) { return e.fieldValue !== '' && e.fieldValue != null && e.fieldValue !== ';' }); // Remove empty items from list 
            if (result.length == 0) { //No useable filter found.
                RemoveAllStatus(); // Clear the filter 
                RemoveNotification(); //Remove notification if still running.
            } else {
                var newJsonString = JSON.stringify(result);
                $('#' + ids.clIdHidJsonObject).val(newJsonString);
                var message = newJsonString;
                UpdateStatus('Filter: ' + message, 'blue');
            }
        }
    }

    function getCurrentListRestUrl() {
        //var pathname = window.location.pathname; // Get the end part of the path name.
        //var pathnameSplitArray = pathname.split('/'); // Split the path to capture the list name.
        //var lstValIndex = pathnameSplitArray.length - 2; // Get the index for the list.
        //var tgtListValue = pathnameSplitArray[lstValIndex]; // Get the list name
        var url = '';
        var spLstObj = new getCurrentListNames();
        var tgtListName = spLstObj.listNameRestFormat; // Delete spaces to use with REST Service.
        var siteUrl = _spPageContextInfo.webServerRelativeUrl;
        if (siteUrl === '/') //This is a top level site.
        {
            url = siteUrl + '_vti_bin/listdata.svc/' + tgtListName + '?'; // Construct the REST Web Service URL for a top level site list.
        } else {
            url = siteUrl + '/_vti_bin/listdata.svc/' + tgtListName + '?'; // Construct the REST Web Service URL for a sub level site list.
        }        
        return url;
    }

    function getCurrentListNames() {
        //var pathname = window.location.pathname; // Get the end part of the path name.
        //var pathnameSplitArray = pathname.split('/'); // Split the path to capture the list name.
        //var lstValIndex = pathnameSplitArray.length - 2; // Get the index for the list.      
        //var tgtListValue = pathnameSplitArray[lstValIndex]; // Get the list name
        //var hidSPListNameValue = decodeURIComponent(tgtListValue); // Do not delete spaces to use with SPList C# code.
        //var tgtListName = decodeURIComponent(tgtListValue).replace(/\s/g, ''); // Delete spaces to use with REST Service.

        var hidSPListNameValue = $('#' + '<%= HidSPListName.ClientID %>').val();
        var tgtListName = hidSPListNameValue.replace(/\s/g, '');
        this.listNameWithSpaces = hidSPListNameValue;
        this.listNameRestFormat = tgtListName;
    }

    var statusId = '';
    var notifyId = '';
    function AddNotification(message, sticky) {
        if (notifyId == '') {
            notifyId = SP.UI.Notify.addNotification('<img src="/_layouts/images/loadingcirclests16.gif" style="vertical-align: top;"/> ' + message, sticky);
        }
    }

    function RemoveNotification() {
        if (notifyId != '') {
            SP.UI.Notify.removeNotification(notifyId);
            notifyId = '';
        }
    }

    function AddStatus(message, color) {
        if (statusId == '') {
            statusId = SP.UI.Status.addStatus(message); // 'blue'
            SP.UI.Status.setStatusPriColor(statusId, color);
        }
    }

    function UpdateStatus(message, color) {
        if (statusId != '') {
            SP.UI.Status.removeStatus(statusId);
        }
        statusId = SP.UI.Status.addStatus(message); // 'blue'
        SP.UI.Status.setStatusPriColor(statusId, color);
        return;
    }

    function RemoveLastStatus() {
        if (statusId != '') {
            SP.UI.Status.removeStatus(statusId);
            statusId = '';
        }
    }

    function RemoveAllStatus() {
        SP.UI.Status.removeAllStatus(true);
    }

    function ConfigFromAndToDatepickersWithAutocomplete(ids, field, fieldType) {
        $(document).ready(function () {
            FormatTbSearchTextForFrom(ids);
            ConfigTbSearchTextFromDate(ids, field, fieldType);
            ConfigTextSearchToDate(ids, field, fieldType);
        });
    }

    function ConfigTbSearchTextFromDate(ids, field, fieldType) {
        $(document).ready(function () {
            var defaultDate = '-2w';
            var minMaxDateOpt = 'minDate';
            ConfigControlForFromAndToDatepicker(ids.clIdTbSearchText, ids.clIdTextSearchToDate, defaultDate, minMaxDateOpt, ids);

            var clIdAuto = ids.clIdTbSearchText;
            ConfigControlForAutocomplete(clIdAuto, ids, field, fieldType);
        });
    }

    function ConfigControlForFromAndToDatepicker(clIdDatepickerFrom, clIdDatepickerTo, defaultDate, minMaxDateOpt, ids) {                
        $('#' + clIdDatepickerFrom).datepicker({
            inline: true,
            showOn: 'button',
            defaultDate: defaultDate,
            changeMonth: true,
            changeYear: true,
            numberOfMonths: 3,
            showButtonPanel: true,
            dateFormat: 'yy-mm-dd',
            onClose: function (selectedDate) {
                $('#' + clIdDatepickerTo).datepicker('option', minMaxDateOpt, selectedDate).next('button').button({ icons: { primary: 'ui-icon-calendar' }, text: false });
                OnFilterChange(ids);
            }
        }).next('button').button({
            icons: {
                primary: 'ui-icon-calendar'
            }, text: false
        });
    }

    function ConfigControlForFromOnly(clIdFrom, ids) {       
        $('#' + clIdFrom).datepicker({
            inline: true,
            showOn: 'button',
            defaultDate: '-2w',
            changeMonth: true,
            changeYear: true,
            numberOfMonths: 3,
            showButtonPanel: true,
            dateFormat: 'yy-mm-dd',
            onClose: function (selectedDate) {
                OnFilterChange(ids);
            }
        }).next('button').button({
            icons: {
                primary: 'ui-icon-calendar'
            }, text: false
        });
    }

    function removeHtmlTags(html) {
        //http://stackoverflow.com/questions/822452/strip-html-from-text-javascript
        var tmp = document.createElement("DIV");
        tmp.innerHTML = html;
        return tmp.textContent || tmp.innerText || "";
    }

    function ConfigControlForAutocomplete(clIdAuto, ids, field, fieldType) {
        $('#' + clIdAuto).autocomplete({            
            source: function (req, add) {                
                var value = req.term;
                value = getLastTermValue(value);
                if (value) {
                    var urlFilter = constructFilterString(ids, value, field, fieldType);
                    if (urlFilter) {
                        var success = function (response) {
                            var uVals = uniqueResults(response.d.results, field, fieldType, value);
                            if (uVals) {
                                add(uVals);
                            }
                            RemoveNotification(); // Clear on success when it returns from the call, asynch.
                        };
                        var req = jqXhrGet(urlFilter, success, field, fieldType);
                        AddNotification('Loading matching values...', true); // Give the user feedback.
                    }
                }
            },
            //character min length before search.
            minLength: 2,
            select: function (event, ui) {
                var txtBoxValue = $('#' + clIdAuto).val();
                var selValue;
                if (fieldType === 'DateTime') {
                    selValue = ui.item.value; // Do not add the semicolon to the end of the field for date values as you can only have one.
                    $('#' + clIdAuto).val(selValue); //set the textbox to the new value
                } else if (fieldType === 'Note') {
                    var noHtmlItemValue = removeHtmlTags(ui.item.value);
                    selValue = noHtmlItemValue + ';'; //add semi to end if it is a text type field as you are allowed to have multiple.                    
                    txtBoxValue = txtBoxValue.substring(0, txtBoxValue.lastIndexOf(';') + 1) + selValue; //grab only the text after the last semicolon.
                    $('#' + clIdAuto).val(txtBoxValue); //set the textbox to the new value
                    return false; //cancel default behaviour.
                } else {
                    selValue = ui.item.value + ';'; //add semi to end if it is a text type field as you are allowed to have multiple.                    
                    txtBoxValue = txtBoxValue.substring(0, txtBoxValue.lastIndexOf(';') + 1) + selValue; //grab only the text after the last semicolon.
                    $('#' + clIdAuto).val(txtBoxValue); //set the textbox to the new value
                    return false; //cancel default behaviour.
                }
            },
            close: function (event, ui) {
                OnFilterChange(ids);                
            },
            focus: function (event, ui) {
                event.preventDefault(); // Prevent the default focus behavior from overwriting the item with the selection is made.  Use the 'Enter' key to make the selection.
            }
        }).keyup(function (e) {            
            if (e.which === 186) { // This is the ';' character on the keyup event.  Close the menu when this key is typed into the text box.
                $('#' + clIdAuto).autocomplete('close');
            } else {
                OnFilterChange(ids);
            }
        }).data("ui-autocomplete")._renderItem = function (ul, item) {
            var thisTermValue = getLastTermValue(this.term);
            var sNeedle = item.label;
            //var iTermLength = this.term.length;
            var iTermLength = thisTermValue.length;
            var tStrPos = new Array();      //Positions of this.term in string
            var iPointer = 0;
            var sOutput = '';
            //Change style here
            var sPrefix = '<strong style="color:#3399FF">';
            var sSuffix = '</strong>';
            //Find all occurence positions            
            tTemp = item.label.toString().toLowerCase().split(thisTermValue.toString().toLowerCase());
            var CharCount = 0;
            tTemp[-1] = '';
            for (i = 0; i < tTemp.length; i++) {
                CharCount += tTemp[i - 1].length;
                tStrPos[i] = CharCount + (i * iTermLength) + tTemp[i].length
            }
            //Apply style
            i = 0;
            if (tStrPos.length > 0) {
                while (iPointer < sNeedle.length) {
                    if (i <= tStrPos.length) {
                        //Needle
                        if (iPointer == tStrPos[i]) {
                            sOutput += sPrefix + sNeedle.substring(iPointer, iPointer + iTermLength) + sSuffix;
                            iPointer += iTermLength;
                            i++;
                        }
                        else {
                            sOutput += sNeedle.substring(iPointer, tStrPos[i]);
                            iPointer = tStrPos[i];
                        }
                    }
                }
            }
            return $("<li></li>")
                .data("item.autocomplete", item)
                .append("<a>" + sOutput + "</a>")
                .appendTo(ul);
        };
    }

    function getLastTermValue(term) {
        var thisTermValue;
        if (term.indexOf(';') > -1) {
            thisTermValue = term.substring(term.lastIndexOf(';') + 1, term.length);
        } else {
            thisTermValue = term;
        }
        return thisTermValue;
    }

    function ConfigTextSearchToDate(ids, field, fieldType) {
        $(document).ready(function () {
            var defaultDate = '+2w';
            var minMaxDateOpt = 'maxDate';
            ConfigControlForFromAndToDatepicker(ids.clIdTextSearchToDate, ids.clIdTbSearchText, defaultDate, minMaxDateOpt, ids);

            var clIdAuto = ids.clIdTextSearchToDate;
            ConfigControlForAutocomplete(clIdAuto, ids, field, fieldType);

        });
    }

    function ProcessConditionalDateTimeSearchFields(ids, field, fieldType) {
        $(document).ready(function () {
            var cmpOpt = $('#' + ids.clIdDdlComparisonOperator).val(); //Get the value of the comparison operator.
            if (cmpOpt === 'daterange' || cmpOpt === 'daterangesoverlap') {
                ConfigFromAndToDatepickersWithAutocomplete(ids, field, fieldType); // the operator is not provided.  Use a From:/To: combination for the dates.
            } else if (cmpOpt === '' || cmpOpt === 'eq' || cmpOpt === 'gt' || cmpOpt === 'geq' || cmpOpt === 'lt' || cmpOpt === 'leq') {
                FormatTbSearchTextForValue(ids); // Configure to be used with Value labels.
                ConfigTbSearchTextAsDatepickerWithAutocomplete(ids, field, fieldType); // Configure to use as datepicker
            } else {
                //TODO: Add Default clause.
            }
        });
    }

    function FormatTbSearchTextForValue(ids) {
        $(document).ready(function () {
            $('#' + ids.clIdDivTextSearchToDate).hide('slide', { direction: 'left' }, 350);
            $('#' + ids.clIdTbSearchText).datepicker('destroy');
            //$('#' + ids.clIdTbSearchText).val(''); // Clear
            $('#' + ids.clIdlblTbSearchText).text('Value:');
            $('#' + ids.clIdTextSearchToDate).datepicker('destroy');
            //$('#' + ids.clIdTextSearchToDate).val(''); // Clear                                
        });
    }

    function FormatTbSearchTextForFrom(ids) {
        $(document).ready(function () {
            $('#' + ids.clIdDivTextSearchToDate).show('slide', { direction: 'left' }, 350);
            $('#' + ids.clIdTbSearchText).datepicker('destroy');
            //$('#' + ids.clIdTbSearchText).val(''); // Clear
            $('#' + ids.clIdlblTbSearchText).text('From:');
            //$('#' + ids.clIdTextSearchToDate).val(''); // Clear         
        });
    }

    function ConfigTbSearchTextAsDatepickerWithAutocomplete(ids, field, fieldType) {
        $(document).ready(function () {
            var clIdFrom = ids.clIdTbSearchText;
            ConfigControlForFromOnly(clIdFrom, ids);
            var clIdAuto = ids.clIdTbSearchText;
            ConfigControlForAutocomplete(clIdAuto, ids, field, fieldType);
        });
    }

    function ProcessConditionalOtherSearchFields(ids, field, fieldType) {
        $(document).ready(function () {
            FormatTbSearchTextForValue(ids);
            var clIdAuto = ids.clIdTbSearchText;
            ConfigControlForAutocomplete(clIdAuto, ids, field, fieldType);
        });
    }

    function isValidDate(value) {
        var rExDtYr = /^[12][0-9]{3}$/;
        this.isValidYear = rExDtYr.test(value);
        var rExDtYrMt = /^\d{4}(\-|\/|\.)\d{1,2}$/;
        this.isValidYearMonth = rExDtYrMt.test(value);
        var rExDtYrMtDy = /^\d{4}(\-|\/|\.)\d{1,2}\1\d{1,2}$/;
        this.isValidYearMonthDay = rExDtYrMtDy.test(value);

        var array = value.split('-');
        this.Year = array[0];
        this.Month = array[1];
        this.Day = array[2];
    }

    function constructFilterString(ids, value, field, fieldType) {
        value = value.substring(value.lastIndexOf(';') + 1);
        var url = getCurrentListRestUrl();
        var urlFilter;
        var filter = '$filter=';
        var topCount = '32'; // Top count.
        var top = '&$top=';
        var orderBy = '&$orderby=';
        var select = '&$select=';
        var expand = '&$expand=';
        var pfxValue = 'Value';  //REST Format uses the field name and appends 'Value' to the field to expand choice values.
        var pfxName = 'Name';
        var pfxTitle = 'Title';
        var pfxId = 'Id';
        var inLineCountAllPages = '&$inlinecount=allpages';
        var eq = '+eq+';
        var ge = '+ge+';
        var le = '+le+';
        var and = '+and+';
        var dateTimeFilter = 'DateTime';
        var yearFilter = 'year';
        var monthFilter = 'month';
        var dayFilter = 'day';
        var singleQuote = "'";
        var str01 = '01'
        var dateSep = '-';
        var comma = ',';
        var openParen = '(';
        var closeParen = ')';
        var fwdSlash = '/';
        var startsWith = 'startswith';
        var subStrOf = 'substringof';
        var asc = '+asc+';
        var desc = '+desc+'
        var columnSelectLimitAscString = select + field + orderBy + field + asc + top + topCount + inLineCountAllPages;
        var urlFilter;
        var cmpOpt = $('#' + ids.clIdDdlComparisonOperator).val();
        if (fieldType === 'Text' || fieldType === 'Computed' || fieldType === 'Note' || fieldType === 'Choice' || fieldType === 'User' || fieldType === 'UserMulti' || fieldType === 'Lookup') {
            if (fieldType === 'Choice') {                
                if (cmpOpt === 'beginswith') {
                    urlFilter = url + filter + startsWith + openParen + field + pfxValue + comma + singleQuote + value + singleQuote + closeParen + expand + field + columnSelectLimitAscString;
                } else {
                    urlFilter = url + filter + subStrOf + openParen + singleQuote + value + singleQuote + comma + field + pfxValue + closeParen + expand + field + columnSelectLimitAscString;
                }
                return urlFilter;
            } else if (fieldType === 'User') {
                columnSelectLimitAscString = select + field + fwdSlash + pfxName + comma + field + fwdSlash + pfxId + orderBy + field + fwdSlash + pfxName + asc + top + topCount + inLineCountAllPages;
                if (cmpOpt === 'beginswith') {
                    urlFilter = url + filter + startsWith + openParen + field + fwdSlash + pfxName + comma + singleQuote + value + singleQuote + closeParen + expand + field + columnSelectLimitAscString;                 
                } else {
                    urlFilter = url + filter + subStrOf + openParen + singleQuote + value + singleQuote + comma + field + fwdSlash + pfxName + closeParen + expand + field + columnSelectLimitAscString;                    
                }
                return urlFilter;
            } else if (fieldType === 'UserMulti') {
                columnSelectLimitAscString = select + field + fwdSlash + pfxName + comma + field + fwdSlash + pfxId;
                urlFilter = url + expand + field + columnSelectLimitAscString;
                return urlFilter;
            } else if (fieldType === 'Lookup') {                
                columnSelectLimitAscString = select + field + fwdSlash + pfxTitle + comma + field + fwdSlash + pfxId + orderBy + field + fwdSlash + pfxTitle + asc + top + topCount + inLineCountAllPages;
                if (cmpOpt === 'beginswith') {
                    urlFilter = url + filter + startsWith + openParen + field + fwdSlash + pfxTitle + comma + singleQuote + value + singleQuote + closeParen + expand + field + columnSelectLimitAscString;                    
                } else {
                    urlFilter = url + filter + subStrOf + openParen + singleQuote + value + singleQuote + comma + field + fwdSlash + pfxTitle + closeParen + expand + field + columnSelectLimitAscString;
                }
                return urlFilter;
            } else {
                if (cmpOpt === 'beginswith') {
                    urlFilter = url + filter + startsWith + openParen + field + comma + singleQuote + value + singleQuote + closeParen + columnSelectLimitAscString;
                } else {
                    urlFilter = url + filter + subStrOf + openParen + singleQuote + value + singleQuote + comma + field + closeParen + columnSelectLimitAscString;
                }
                return urlFilter;
            }            
        } else if (fieldType === 'DateTime') {
            var dt = new isValidDate(value);
            if (cmpOpt === 'daterange' || cmpOpt === 'daterangesoverlap' || cmpOpt === '' || cmpOpt === 'eq' || cmpOpt === 'gt' || cmpOpt === 'geq' || cmpOpt === 'lt' || cmpOpt === 'leq') {
                if (dt.isValidYear) { // The year is only included on typed text
                    urlFilter = url + filter + field + ge + dateTimeFilter + singleQuote + dt.Year + dateSep + str01 + dateSep + str01 + singleQuote + columnSelectLimitAscString;
                    return urlFilter;
                } else if (dt.isValidYearMonth) { // Year and Month provided.
                    var monthVal = dt.Month; //monthVal = monthVal.replace(/^0+/, ''); removes the leading zero.
                    urlFilter = url + filter + field + ge + dateTimeFilter + singleQuote + dt.Year + dateSep + monthVal + dateSep + str01 + singleQuote + columnSelectLimitAscString;
                    return urlFilter;
                } else { // Complete date is included format: 2016-02-08.  Allows to filter by year, month, day.
                    urlFilter = url + filter + field + ge + dateTimeFilter + singleQuote + value + singleQuote + columnSelectLimitAscString;
                    return urlFilter;
                }
            }
        } else if (fieldType === 'Number' || fieldType === 'Counter' || fieldType === 'Currency') {
            if (cmpOpt === 'lt' || cmpOpt === 'leq') {
                urlFilter = url + filter + field + le + value + columnSelectLimitAscString;
            } else {
                urlFilter = url + filter + field + ge + value + columnSelectLimitAscString;
            }           
            return urlFilter;
        }
    }

    function TextFieldContainsCamlQueryBuild(inVal, fieldName, lgcOpt, xml, isNewQuery) {
        var query;
        $.each(inVal, function (index, element) {//More than one contains value provided
            if (index == 0 && isNewQuery) {//Build first contains.
                xml = new CamlBuilder().View().Query().Where().TextField(fieldName).Contains(inVal[index]).ToString(); // Will occur on the first item.
            } else {//Add other contains.
                if (lgcOpt === 'or' || lgcOpt === '') {
                    query = CamlBuilder.FromXml(xml).ModifyWhere().AppendOr().TextField(fieldName).Contains(inVal[index]).ToString();
                    xml = query; //Continue to add or(s) if there are multiple contains in the array.
                } else {
                    query = CamlBuilder.FromXml(xml).ModifyWhere().AppendAnd().TextField(fieldName).Contains(inVal[index]).ToString();
                    xml = query; //Continue to add and(s) if there are multiple contains in the array.
                }
            }
        });
        return xml;
    }

    function TextFieldCamlQueryBuild(inVal, fieldName, lgcOpt, cmpOpt, xml, isNewQuery) {
        var query;
        if (cmpOpt === 'eq') {
            $.each(inVal, function (index, element) {//More than one eq value provided
                if (index == 0 && isNewQuery) {//Build first eq.
                    xml = new CamlBuilder().View().Query().Where().TextField(fieldName).EqualTo(inVal[index]).ToString(); // Will occur on the first item.
                } else {//Add other contains.
                    if (lgcOpt === 'or' || lgcOpt === '') {
                        query = CamlBuilder.FromXml(xml).ModifyWhere().AppendOr().TextField(fieldName).EqualTo(inVal[index]).ToString();
                        xml = query; //Continue to add or(s) if there are multiple eq in the array.
                    } else {
                        query = CamlBuilder.FromXml(xml).ModifyWhere().AppendAnd().TextField(fieldName).EqualTo(inVal[index]).ToString();
                        xml = query; //Continue to add and(s) if there are multiple eq in the array.
                    }
                }
            });
        } else if (cmpOpt === 'beginswith') {
            $.each(inVal, function (index, element) {//More than one beginswith value provided
                if (index == 0 && isNewQuery) {//Build first contains. 
                    xml = new CamlBuilder().View().Query().Where().TextField(fieldName).BeginsWith(inVal[index]).ToString();
                } else {//Add other beginswith.
                    if (lgcOpt === 'or' || lgcOpt === '') {
                        query = CamlBuilder.FromXml(xml).ModifyWhere().AppendOr().TextField(fieldName).BeginsWith(inVal[index]).ToString();
                        xml = query; //Continue to add or(s) if there are multiple beginswith in the array. Or is the only possible choice as there is only beginswith per item.
                    } else {
                        query = CamlBuilder.FromXml(xml).ModifyWhere().AppendAnd().TextField(fieldName).BeginsWith(inVal[index]).ToString();
                        xml = query; //Continue to add or(s) if there are multiple beginswith in the array. Or is the only possible choice as there is only beginswith per item.
                    }
                }
            });
        } else {
            xml = TextFieldContainsCamlQueryBuild(inVal, fieldName, lgcOpt, xml, isNewQuery);
        }
        return xml; 
    }

    function DateFieldCamlQueryBuild(inVal, fieldName, dateFrom, dateTo, lgcOpt, cmpOpt, xml, isNewQuery) {
        var query;
        if (cmpOpt === 'daterange' || cmpOpt === 'daterangesoverlap') {
            if (inVal.length === 2 && dateFrom !== '' && dateTo !== '') { // There are date from and to values.
                if (isNewQuery) {
                    xml = new CamlBuilder().View().Query().Where().DateField(fieldName).GreaterThanOrEqualTo(dateFrom).And().DateField(fieldName).LessThanOrEqualTo(dateTo).ToString();
                } else {
                    query = CamlBuilder.FromXml(xml).ModifyWhere().AppendOr().DateField(fieldName).GreaterThanOrEqualTo(dateFrom).And().DateField(fieldName).LessThanOrEqualTo(dateTo).ToString();
                }                
            } else { //Only one date provided.
                if (isNewQuery) {
                    xml = new CamlBuilder().View().Query().Where().DateField(fieldName).EqualTo(inVal).ToString();
                } else {
                    query = CamlBuilder.FromXml(xml).ModifyWhere().AppendOr().DateField(fieldName).EqualTo(inVal).ToString();
                }               
            }
        } else { //Only one date provided.
            if (isNewQuery) {
                xml = new CamlBuilder().View().Query().Where().DateField(fieldName).EqualTo(inVal).ToString();
            } else {
                query = CamlBuilder.FromXml(xml).ModifyWhere().AppendOr().DateField(fieldName).EqualTo(inVal).ToString();
            }
        }
        return xml;
    }

    function NumberFieldCamlQueryBuild(inVal, fieldName, lgcOpt, cmpOpt, xml, isNewQuery) {
        var query;
        if (cmpOpt === 'gt') {
            $.each(inVal, function (index, element) {//More than one gt value provided
                if (index == 0 && isNewQuery) {//Build first contains. 
                    xml = new CamlBuilder().View().Query().Where().NumberField(fieldName).GreaterThan(inVal[index]).ToString();
                } else {//Add other greater than.
                    if (lgcOpt === 'or' || lgcOpt === '') {
                        query = CamlBuilder.FromXml(xml).ModifyWhere().AppendOr().NumberField(fieldName).GreaterThan(inVal[index]).ToString();
                        xml = query; //Continue to add or(s) if there are multiple greater than in the array. Or is the only possible choice as there is only beginswith per item.
                    } else {
                        query = CamlBuilder.FromXml(xml).ModifyWhere().AppendAnd().NumberField(fieldName).GreaterThan(inVal[index]).ToString();
                        xml = query; //Continue to add or(s) if there are multiple greater than in the array. Or is the only possible choice as there is only beginswith per item.
                    }
                }
            });
        } else if (cmpOpt === 'geq') {
            $.each(inVal, function (index, element) {//More than one gt value provided
                if (index == 0 && isNewQuery) {//Build first contains. 
                    xml = new CamlBuilder().View().Query().Where().NumberField(fieldName).GreaterThanOrEqualTo(inVal[index]).ToString();
                } else {//Add other greater than.
                    if (lgcOpt === 'or' || lgcOpt === '') {
                        query = CamlBuilder.FromXml(xml).ModifyWhere().AppendOr().NumberField(fieldName).GreaterThanOrEqualTo(inVal[index]).ToString();
                        xml = query; //Continue to add or(s) if there are multiple greater than or equal in the array. Or is the only possible choice as there is only beginswith per item.
                    } else {
                        query = CamlBuilder.FromXml(xml).ModifyWhere().AppendAnd().NumberField(fieldName).GreaterThanOrEqualTo(inVal[index]).ToString();
                        xml = query; //Continue to add or(s) if there are multiple greater than or equal in the array. Or is the only possible choice as there is only beginswith per item.
                    }
                }
            });
        } else if (cmpOpt === 'lt') {
            $.each(inVal, function (index, element) {//More than one gt value provided
                if (index == 0 && isNewQuery) {//Build first contains. 
                    xml = new CamlBuilder().View().Query().Where().NumberField(fieldName).LessThan(inVal[index]).ToString();
                } else {//Add other greater than.
                    if (lgcOpt === 'or' || lgcOpt === '') {
                        query = CamlBuilder.FromXml(xml).ModifyWhere().AppendOr().NumberField(fieldName).LessThan(inVal[index]).ToString();
                        xml = query; //Continue to add or(s) if there are multiple less than in the array. Or is the only possible choice as there is only beginswith per item.
                    } else {
                        query = CamlBuilder.FromXml(xml).ModifyWhere().AppendAnd().NumberField(fieldName).LessThan(inVal[index]).ToString();
                        xml = query; //Continue to add or(s) if there are multiple less than in the array. Or is the only possible choice as there is only beginswith per item.
                    }
                }
            });
        } else if (cmpOpt === 'leq') {
            $.each(inVal, function (index, element) {//More than one gt value provided
                if (index == 0 && isNewQuery) {//Build first contains. 
                    xml = new CamlBuilder().View().Query().Where().NumberField(fieldName).LessThanOrEqualTo(inVal[index]).ToString();
                } else {//Add other greater than.
                    if (lgcOpt === 'or' || lgcOpt === '') {
                        query = CamlBuilder.FromXml(xml).ModifyWhere().AppendOr().NumberField(fieldName).LessThanOrEqualTo(inVal[index]).ToString();
                        xml = query; //Continue to add or(s) if there are multiple less than or equal in the array. Or is the only possible choice as there is only beginswith per item.
                    } else {
                        query = CamlBuilder.FromXml(xml).ModifyWhere().AppendAnd().NumberField(fieldName).LessThanOrEqualTo(inVal[index]).ToString();
                        xml = query; //Continue to add or(s) if there are multiple less than or equal in the array. Or is the only possible choice as there is only beginswith per item.
                    }
                }
            });
        } else {
            xml = new CamlBuilder().View().Query().Where().NumberField(fieldName).In(inVal).ToString();
        }
        return xml;
    }
     
    function CamlJsQueryBuildItems(array) {
        var xml;
        $.each(array, function (index, element) {
            var fieldName = element.fieldName;
            var fieldType = element.fieldType;
            var fieldValue = element.fieldValue;
            var lgcOpt = element.logicalOperator;
            var cmpOpt = element.comparisonOperator;
            if (fieldValue) {
                var arr;
                var inVal;
                var dateFrom, dateTo;
                if (fieldValue.indexOf(';') > -1) {
                    arr = fieldValue.split(';');
                    inVal = removeNullEmptyFromArray(arr);
                } else {
                    arr = new Array(fieldValue);
                    inVal = arr;
                }                
                dateFrom = inVal[0];
                dateTo = inVal[1];
                if (index == 0) {//Build firt element. 
                    var isNewQuery = true; //Build the new query on the first item.                    
                } else {
                    var isNewQuery = false; //It is not a new query, add to subsequent queries.                                  
                } // index == 0
                               
                if (fieldType === 'Text' || fieldType === 'Computed' || fieldType === 'Note' || fieldType === 'Choice' || fieldType === 'User' || fieldType === 'UserMulti' || fieldType === 'Lookup') {
                    xml = TextFieldCamlQueryBuild(inVal, fieldName, lgcOpt, cmpOpt, xml, isNewQuery);
                } else if (fieldType === 'DateTime') {
                    xml = DateFieldCamlQueryBuild(inVal, fieldName, dateFrom, dateTo, lgcOpt, cmpOpt, xml, isNewQuery);
                } else if (fieldType === 'Number' || fieldType === 'Counter' || fieldType === 'Currency') {
                    xml = NumberFieldCamlQueryBuild(inVal, fieldName, lgcOpt, cmpOpt, xml, isNewQuery);
                } else {
                    xml = TextFieldCamlQueryBuild(inVal, fieldName, lgcOpt, cmpOpt, xml, isNewQuery); // Default, using TextField.
                }
            } // fieldValue
        });
        return xml;
    }

    function BuildCamlJsQuery(ids) {
        var oldJsonString = $('#' + ids.clIdHidJsonObject).val();
        if (!oldJsonString) return false;
        var array = JSON.parse(oldJsonString);        
        var xml, innerWhereQuery;
        xml = CamlJsQueryBuildItems(array);        
        if (xml) {            
            xml = xml.replace('<View><Query>', ''); //Remove tags so view works corretly with view format.
            innerWhereQuery = xml.replace('</Query></View>', '');
        }       
        return innerWhereQuery;
    }

    function isNumeric(n) {
        return !isNaN(parseFloat(n)) && isFinite(n);
    }

    // jQuery XMLHTTPRequest GET
    function jqXhrGet(url, success, field, fieldType) {        
        return $.ajax({
            url: url,
            method: 'GET',
            headers: { 'Accept': 'application/json; odata=verbose' },
            success: success
        });
    }

    function uniqueResults(results, field, fieldType, value) {        
        var uVals = [];                
        $.each(results, function (index, element) {
            if (fieldType === 'DateTime') {
                var dateStr = jsonDateToJsDateFormat(element[field], 'yy-mm-dd');
                if ($.inArray(dateStr, uVals) === -1) {
                    uVals.push(dateStr);
                }
            } else if (fieldType === 'Choice') {
                var choiceStr = element[field].Value.toString();
                if ($.inArray(choiceStr, uVals) === -1) {
                    uVals.push(choiceStr);
                }
            } else if (fieldType === 'User') {
                var userStr = element[field].Name.toString();
                if ($.inArray(userStr, uVals) === -1) {
                    uVals.push(userStr);
                }
            } else if (fieldType === 'Lookup') {
                var lookupStr = element[field].Title.toString();
                if ($.inArray(lookupStr, uVals) === -1) {
                    uVals.push(lookupStr);
                }
            } else if (fieldType === 'UserMulti') {
                var multiUsrvals = [];
                multiUsrvals = element[field].results;
                if (multiUsrvals.length > 0) {
                    var usrMulti = [];
                    $.each(multiUsrvals, function (i, e) {
                        usrMulti.push(e.Name);
                    });
                    var fldVal = usrMulti.join(';').toString();
                    var usrJoin = fldVal.toLowerCase();
                    var eVal = value.toLowerCase();
                    if (usrJoin.indexOf(eVal) > -1) {
                        if ($.inArray(fldVal, uVals) === -1) {
                            uVals.push(fldVal);                            
                        }                        
                    }
                }
            } else {
                var elementVal = element[field].toString();
                if ($.inArray(elementVal, uVals) === -1) {
                    uVals.push(elementVal);
                }
            }
        });
        return uVals;
    }
        
    function jsonDateToJsDateFormat(dateElement, format) {
        var date = new Date(parseInt(dateElement.substring(6)));
        var dateStr = $.datepicker.formatDate(format, date);
        return dateStr;
    }

    function UpdateCurrentView(ids, query)
    {
        //creating the client context
        var clientContext = new SP.ClientContext.get_current();
        if (clientContext != undefined && clientContext != null) {
            //get the current web
            var web = clientContext.get_web();
            //get all lists
            var listCollection = web.get_lists();
            var listName = $('#' + ids.clIdHidSPListName).val();            
            var list = listCollection.getByTitle(listName);
            //Use current user information as the view name.
            //get the view collection to add the view
            var viewcollection = list.get_views();
            var viewName = $('#' + ids.clIdHidSPViewName).val();
            var view = list.get_views().getByTitle(viewName);
            if (query) {
                view.set_viewQuery(query);
                view.update();
                clientContext.load(view);
                //execute the operation async - call onCreateUpdateViewQueryFailed on errors and onCreateUpdateViewQuerySucceeded on success
                clientContext.executeQueryAsync(Function.createDelegate(this, this.onSuccessUpdateViewQuery), Function.createDelegate(this, this.onFailQueryNotProcessed));
            }                        
        }
    }

    function ClearCurrentView(ids)
    {
        //creating the client context
        var clientContext = new SP.ClientContext.get_current();
        if (clientContext != undefined && clientContext != null) {
            //get the current web
            var web = clientContext.get_web();
            //get all lists
            var listCollection = web.get_lists();
            var listName = $('#' + ids.clIdHidSPListName).val();
            var list = listCollection.getByTitle(listName);
            //Use current user information as the view name.
            //get the view collection to add the view
            var viewcollection = list.get_views();
            var viewName = $('#' + ids.clIdHidSPViewName).val();
            var view = list.get_views().getByTitle(viewName);
            //Build the CAML query.           
            var query = SP.CamlQuery.createAllItemsQuery();
            view.set_viewQuery(query);
            view.update();
            clientContext.load(view);
            //execute the operation async - call onCreateUpdateViewQueryFailed on errors and onCreateUpdateViewQuerySucceeded on success
            clientContext.executeQueryAsync(Function.createDelegate(this, this.onSuccessUpdateViewQuery), Function.createDelegate(this, this.onFailQueryNotProcessed));           
        }
    }

    function onSuccessUpdateViewQuery(sender, args) {
        //Refresh the web part.
        var viewId = $('#' + '<%= HidCurrentViewID.ClientID %>').val();
        var selectedListId = SP.ListOperation.Selection.getSelectedList();
        var convertedListId = viewId.toLowerCase().replace("-", "_").replace("{", "").replace("}", "");
        var controlId = 'ctl00$m$g_' + convertedListId + '$ctl02';
        __doPostBack(controlId, 'cancel');
        //Comment above and uncomment below to refresh the view using the native refresh button.
        //$('#ManualRefresh').parent().trigger('click');
    }

    function onFailQueryNotProcessed(sender, args) {
        alert(args.get_message());
    }

    function NotifyAppErrorMessage(message) {
        $('#' + 'AppMessageError').text(message);
    }

    function ClearAppErrorMessage() {
        $('#' + 'AppMessageError').text('');
    }
    
</script>

<div class="ms-error" id="AppMessageError" style="width: 810px"></div>
<asp:HiddenField ID="HidJsonObject" runat="server" />
<asp:HiddenField ID="HidSPListName" runat="server" />
<asp:HiddenField ID="HidSiteRestUrl" runat="server" />
<asp:HiddenField ID="HidCamlQuery" runat="server" />
<asp:HiddenField ID="HidSPViewName" runat="server" />
<asp:HiddenField ID="HidCurrentViewID" runat="server" />
<script type="text/javascript">
    //Uncomment if restoring the originally loade jQuery version.
    //window.jQuery = jQLoaded;
    //window.$ = jQLoaded;
    //console.log('AFTER jQuery version: ' + $.fn.jquery);
</script>      
<!-- End of MY application -->

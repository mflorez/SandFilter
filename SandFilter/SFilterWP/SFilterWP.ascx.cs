using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.ComponentModel;
using System.Web.UI.WebControls.WebParts;
using System.Web;
using Microsoft.SharePoint;

namespace SandFilter.SFilterWP
{
    [ToolboxItemAttribute(false)]
    public partial class SFilterWP : WebPart
    {
        // Uncomment the following SecurityPermission attribute only when doing Performance Profiling on a farm solution
        // using the Instrumentation method, and then remove the SecurityPermission attribute when the code is ready
        // for production. Because the SecurityPermission attribute bypasses the security check for callers of
        // your constructor, it's not recommended for production purposes.
        // [System.Security.Permissions.SecurityPermission(System.Security.Permissions.SecurityAction.Assert, UnmanagedCode = true)]
        public SFilterWP()
        {
        }        

        protected override void OnInit(EventArgs e)
        {
            base.OnInit(e);
            InitializeControl();
            BindDataControls();
        }      

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {                         
            }
        }

        protected void BindDataControls()
        {
            List<OptionEntity> items = GetSharePointListFieldItems();            
            DdlListFields.DataSource = items;
            DdlListFields.DataTextField = "Title";
            DdlListFields.DataValueField = "Id";
            DdlListFields.DataBind();
        }

        /// <summary>
        /// Perform system update on the list items to force calculated fields to update.
        /// </summary>
        protected void ProcessSystemUpdate()
        {
            SPWeb web = SPContext.Current.Web;
            string listName = ActiveListName;
            SPList list = web.Lists[listName];
            web.AllowUnsafeUpdates = true;
            foreach (SPListItem item in list.Items)
            {
                item.SystemUpdate(); //Updates the database with changes made to the list item without changing the Modified or Modified By fields.  Useful when recalculating the TODAY() in a calculated field.
            }
            web.AllowUnsafeUpdates = false;
        }

        /// <summary>
        /// Is hidden view setting.
        /// </summary>
        protected bool IsHiddenView = false;

        protected string ActiveListName
        {
            get
            {
                SPWeb web = SPContext.Current.Web;
                string listUrl = Page.Request.Url.AbsolutePath; //HttpContext.Current.Request.Url.GetComponents(UriComponents.Path, UriFormat.SafeUnescaped);
                SPList currentList = SPContext.Current.Web.GetListFromUrl(listUrl);
                string currentListName = currentList.Title;
                return currentListName;                
            }
        }

        protected string ActiveListViewName
        {
            get
            {
                SPWeb web = SPContext.Current.Web;
                string viewUrl = Page.Request.Url.AbsolutePath; //HttpContext.Current.Request.Url.GetComponents(UriComponents.Path, UriFormat.SafeUnescaped);
                SPView currentView = SPContext.Current.Web.GetViewFromUrl(viewUrl);
                string currentViewName = currentView.Title;
                return currentViewName;                
            }
        }

        /// <summary>
        /// Gets the share point list field items.
        /// </summary>
        /// <param name="filterCriteria">The filter criteria.</param>
        private List<OptionEntity> GetSharePointListFieldItems()
        {
            List<OptionEntity> fieldItems = new List<OptionEntity>();
            fieldItems = new List<OptionEntity>();
            OptionEntity item;
            SPField field;
            string viewName = ActiveListViewName;
            string listName = ActiveListName;
            
            SPWeb web = SPContext.Current.Web;
            string currentUserNameAsViewName = web.CurrentUser.Name;
            SPList list = web.Lists[listName];
            SPView userView;
            bool hasView = list.HasView(currentUserNameAsViewName);

            if (hasView) // If the value of the viewGuid parameter is Empty, this method returns the default view available to the current user.
            {
                userView = list.Views[currentUserNameAsViewName];
            }
            else
            {
                userView = list.Views[viewName];
            }
            StringCollection viewFieldCollection = userView.ViewFields.ToStringCollection();
            //Uncomment to add an first empty value.
            //item = new OptionEntity();
            //item.Id = "" + ";" + "";
            //item.Title = "";
            //fieldItems.Add(item);
            string fldInternalName = string.Empty;
            string fldOutputType = string.Empty;
            string fieldTitle = string.Empty;
            
            List<string> omitColumnList = new List<string>(new string[] { "Edit", "Attachments" }); //Omit column list.
            
            foreach (string viewField in viewFieldCollection)
            {
                field = list.Fields.GetFieldByInternalName(viewField);
                item = new OptionEntity();                
                fldInternalName = field.InternalName;
                fieldTitle = field.Title;
                if (!omitColumnList.Contains(fieldTitle))
                {
                    if (field.TypeAsString.Equals("Calculated"))
                    {
                        SPFieldCalculated cField = (SPFieldCalculated)field;
                        fldOutputType = cField.OutputType.ToString();//Use calculated return type to use on the CAML query.                    
                    }
                    else
                    {
                        fldOutputType = field.TypeAsString;
                    }
                    item.Id = fldInternalName + ";" + fldOutputType;
                    item.Title = fieldTitle;
                    fieldItems.Add(item);
                }
            }
            return fieldItems;
        }

        protected void ClearListFilter()
        {
           string listName, viewName, pageUrl;
                listName = ActiveListName;
                viewName = ActiveListViewName;
                pageUrl = HidSiteRestUrl.Value;
                string viewUrl = ResetSPUserView(listName, viewName, pageUrl);                                
        }
                

        protected string UpdateSPUserView(string listName, string viewName, string pageUrl, string camlQuery)
        {
            using (SPWeb web = SPContext.Current.Web)
            {
                SPList list = web.Lists[listName];
                string currentUserNameAsViewName = web.CurrentUser.Name;

                bool hasView = list.HasView(currentUserNameAsViewName);

                if (hasView) // If the value of the viewGuid parameter is Empty, this method returns the default view available to the current user.
                {
                    SPView userView = list.Views[currentUserNameAsViewName];
                    userView.Query = camlQuery;
                    userView.Hidden = IsHiddenView;
                    userView.Update();
                    string viewUrl = userView.Url;                    
                    return viewUrl;
                }
                else
                {
                    SPView userView = list.Views[viewName].Clone(currentUserNameAsViewName, list.DefaultView.RowLimit, list.DefaultView.Paged, false);
                    userView.Query = camlQuery;
                    userView.Hidden = IsHiddenView;
                    userView.Update();
                    string viewUrl = userView.Url;                    
                    return viewUrl;
                }
            }
        }

        protected string ResetSPUserView(string listName, string viewName, string pageUrl)
        {
            using (SPWeb web = SPContext.Current.Web)
            {
                SPList list = web.Lists[listName];
                string currentUserNameAsViewName = web.CurrentUser.Name;
                string allItemsCamlQuery = @"<OrderBy><FieldRef Name=""ID""/></OrderBy>";
                bool hasView = list.HasView(currentUserNameAsViewName);

                if (hasView) // If the value of the viewGuid parameter is Empty, this method returns the default view available to the current user.
                {
                    SPView userView = list.Views[currentUserNameAsViewName];
                    userView.Query = allItemsCamlQuery;
                    userView.Hidden = IsHiddenView;
                    userView.Update();
                    string viewUrl = userView.Url;
                    //string[] page = listUrl.Split('/');
                    //string val = page[page.Length - 1];
                    return viewUrl;
                }
                else
                {
                    SPView userView = list.Views[viewName].Clone(currentUserNameAsViewName, list.DefaultView.RowLimit, list.DefaultView.Paged, false);
                    userView.Query = allItemsCamlQuery;
                    userView.Hidden = IsHiddenView;
                    userView.Update();
                    string viewUrl = userView.Url;
                    //string[] page = listUrl.Split('/');
                    //string val = page[page.Length - 1];
                    return viewUrl;
                }
            }
        }

    }
}

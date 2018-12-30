using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using Newtonsoft.Json;

public class RowData
{
    public string firstname, lastname, productname;
    public float quantity, price;
    public bool available;

    public RowData(string firstname, string lastname, string productname)
    {
        this.firstname = firstname;
        this.lastname = lastname;
        this.productname = productname;
        this.quantity = 5;
        this.price = 59;
        this.available = quantity > 0;
    }
}

public partial class _Default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    [WebMethod]
    public static string GetJson(int page, int pageSize)
    {
        var data = new List<RowData> { new RowData("Salomon", "Sanchez", "iSoftware") };
        var json = JsonConvert.SerializeObject(data);
        return "{\"header\":{\"hash\":\"111222333444\"},\"data\":" + json + "}";
    }

    public void Download()
    {
        string filePath = "C:\\test.txt";
        FileInfo file = new FileInfo(filePath);
        if (file.Exists)
        {
            Response.Clear();
            Response.ClearHeaders();
            Response.ClearContent();
            Response.AddHeader("Content-Disposition", "attachment; filename=" + file.Name);
            Response.AddHeader("Content-Length", file.Length.ToString());
            Response.ContentType = "text/plain";
            Response.Flush();
            Response.TransmitFile(file.FullName);
            Response.End();
        }
    }
}
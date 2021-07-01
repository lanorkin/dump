<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">
  void btnSubmit_Click(object sender, EventArgs e)
  {
    var dataTable = new DataTable();
    using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings[ctlDbSelector.SelectedValue].ConnectionString))
    {
      connection.Open();
      var command = connection.CreateCommand();
      command.CommandText = txtQuery.Text;
      command.CommandTimeout = 120000;

      using(var dataAdapter = new SqlDataAdapter(command))
      {
        dataAdapter.Fill(dataTable);
      }
    }

    lblTotalRows.Text = "Number of rows: " + dataTable.Rows.Count;
    lblTotalRows.Visible = true;

    ctlGrid.DataSource = dataTable;
    ctlGrid.Visible = true;
    ctlGrid.DataBind();
  }

</script>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
  <title>Title</title>
</head>
<body>
<form id="HtmlForm" runat="server" >
  <div>
    <asp:Label runat="server" AssociatedControlID="ctlDbSelector">Database: </asp:Label>
    <asp:RadioButtonList runat="server" ID="ctlDbSelector" RepeatDirection="Horizontal" RepeatLayout="Flow">
      <asp:ListItem Value="EPiServerDB">Cms</asp:ListItem>
      <asp:ListItem Value="EcfSqlConnection" Selected="True">Commerce</asp:ListItem>
    </asp:RadioButtonList>
  </div>
  <div>
    <asp:Label runat="server" AssociatedControlID="txtQuery">Query: </asp:Label>
    <asp:TextBox runat="server" ID="txtQuery" TextMode="MultiLine" Rows="5" Columns="80" />
  </div>
  <div style="margin-bottom: 3em">
    <asp:Button runat="server" Text="Submit" OnClick="btnSubmit_Click" />
  </div>
  
  <div style="margin: 1em">
    <asp:Label runat="server" ID="lblTotalRows" Visible="False" />
  </div>
  
  <asp:DataGrid runat="server" ID="ctlGrid" Visible="False" />
</form>
</body>
</html>
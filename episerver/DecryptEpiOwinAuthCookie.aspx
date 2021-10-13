<%@ Page Language="C#" AutoEventWireup="true" %>

<%@ Import Namespace="System.Globalization" %>
<%@ Import Namespace="System.Web" %>
<%@ Import Namespace="Microsoft.AspNet.Identity.Owin" %>
<%@ Import Namespace="Microsoft.Owin.Security.Cookies" %>
<%@ Import Namespace="Microsoft.Owin.Security.DataHandler" %>
<%@ Import Namespace="EPiServer.Cms.UI.AspNetIdentity" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Decrypt EpiServer OWIN Auth Cookie</title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <asp:TextBox runat="server" ID="txtCookieValue" TextMode="MultiLine" Style="width: 500px; height: 200px" placeholder="Cookie value"></asp:TextBox>
        </div>
        <div>
            <asp:Button runat="server" ID="btnDecrypt" Text="Decrypt" OnClick="btnDecrypt_Click" />
        </div>
        <asp:Panel runat="server" Visible="false" ID="panResult">
            <div style="margin-top: 40px;">
                <div>
                    Is Authenticated:
                    <asp:Label runat="server" ID="lblIsAuthenticated"></asp:Label>
                </div>
                <div>
                    Name:
                    <asp:Label runat="server" ID="lblName"></asp:Label>
                </div>
                <div>
                    Authentication Type:
                    <asp:Label runat="server" ID="lblAuthenticationType"></asp:Label>
                </div>
                <div>
                    Role Claim Type:
                    <asp:Label runat="server" ID="lblRoleClaimType"></asp:Label>
                </div>
                <div>
                    Name Claim Type:
                    <asp:Label runat="server" ID="lblNameClaimType"></asp:Label>
                </div>
            </div>

            <div style="margin-top: 40px;">
                Claims:
                <asp:DataGrid runat="server" ID="ctlClaimsGrid"></asp:DataGrid>
            </div>

            <div style="margin-top: 40px;">
                Properties:
                <div style="margin-top: 20px;">
                    Issued:
                    <asp:Label runat="server" ID="lblIssued"></asp:Label>
                    <br />
                    Expired:
                    <asp:Label runat="server" ID="lblExpired"></asp:Label>
                </div>
                <asp:DataGrid runat="server" ID="ctlPropertiesGrid" Style="margin-top: 40px;"></asp:DataGrid>
            </div>
        </asp:Panel>

        <div style="margin-top: 40px;">
            <asp:Label runat="server" ID="lblError"></asp:Label>
        </div>
    </form>
</body>
</html>

<script runat="server">
    protected void btnDecrypt_Click(object sender, EventArgs e)
    {
        var cookieValue = txtCookieValue.Text;

        if (string.IsNullOrWhiteSpace(cookieValue))
        {
            lblError.Text = "Nothing to decrypt";
            return;
        }

        var owinContext = HttpContext.Current.GetOwinContext();
        var applicationOptions = owinContext.Get<ApplicationOptions>();
        var dataProtector = applicationOptions.DataProtectionProvider.Create(typeof(CookieAuthenticationMiddleware).FullName, "ApplicationCookie", "v1");

        var ticketDataFormat = new TicketDataFormat(dataProtector);
        var ticket = ticketDataFormat.Unprotect(cookieValue);

        if (ticket != null)
        {
            panResult.Visible = true;

            lblName.Text = ticket.Identity.Name;
            lblIsAuthenticated.Text = ticket.Identity.IsAuthenticated.ToString();
            lblAuthenticationType.Text = ticket.Identity.AuthenticationType;
            lblRoleClaimType.Text = ticket.Identity.RoleClaimType;
            lblNameClaimType.Text = ticket.Identity.NameClaimType;

            ctlClaimsGrid.DataSource = ticket.Identity.Claims;
            ctlClaimsGrid.DataBind();

            ctlPropertiesGrid.DataSource = ticket.Properties.Dictionary;
            ctlPropertiesGrid.DataBind();

            lblIssued.Text = ticket.Properties.IssuedUtc?.ToString("o", CultureInfo.InvariantCulture) ?? string.Empty;
            lblExpired.Text = ticket.Properties.ExpiresUtc?.ToString("o", CultureInfo.InvariantCulture) ?? string.Empty;
        }
        else
        {
            lblError.Text = "Failed to decrypt";
        }
    }
</script>

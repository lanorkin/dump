<%@ Page Language="C#" AutoEventWireup="true" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
  <title>Membership users login</title>
  <%
      string newLogin = Request.QueryString["login"];
      if (!string.IsNullOrEmpty(newLogin)) {
        FormsAuthentication.SetAuthCookie(newLogin, true);
  %><meta http-equiv="refresh" content="0; url=?"><%
    }
  %>

</head>
<body>
    <form id="form1" runat="server">
<%
    string cookieValue;
    string cookieData;

    HttpCookie cookie = Request.Cookies[FormsAuthentication.FormsCookieName];
    if (cookie == null)
    {
      cookieValue = null;
      cookieData = string.Empty;
    }
    else
    {
      cookieValue = cookie.Value;
      try
      {
        var ticket = FormsAuthentication.Decrypt(cookieValue);
        cookieData = "DECRYPTED: " + ticket.Name;
        if (!string.IsNullOrWhiteSpace(ticket.UserData))
        {
          cookieData += ", " + ticket.UserData;
        }
      }
      catch (Exception ex)
      {
        cookieData = "CAN NOT DECRYPT: " + ex.Message;
      }
    }
%>

<%
    string newLogin = Request.QueryString["login"];
    if (!string.IsNullOrWhiteSpace(newLogin))
    {
%><h1>Logging in as <%=newLogin %>...</h1><%
    }
%>

<pre>
    HOST: <%= Environment.MachineName %>
    Now:  <%= DateTime.Now %>

    Authenticated: <%= Context.User.Identity.IsAuthenticated %>
    User name:     <%= Context.User.Identity.Name %>
    Roles:         <%= string.Join(", ", System.Web.Security.Roles.GetRolesForUser()) %>

    Auth Cookie:   <%= cookieValue == null ? "no cookie" : cookieValue %>
    Ticket info:   <%= cookieData %>

    Users:<%
    var users = Membership.GetAllUsers();
    foreach (MembershipUser user in users)
    { %>
        <a href="?login=<%= HttpUtility.HtmlEncode(user.UserName) %>"><%= HttpUtility.HtmlEncode(user.UserName) %></a> (<%=string.Join(", ", System.Web.Security.Roles.GetRolesForUser(user.UserName)) %>) <%}
%>
</pre>

    </form>
</body>
</html>

import openpyxl
from ldap3 import Server, Connection, ALL, NTLM, MODIFY_REPLACE

AD_SERVER = 'WIN-08MBGJ3K685.saravana.com'
AD_USER = 'SARAVANA\\adminuser'   # AD admin
AD_PASSWORD = 'AdminPassword'     # secure later

EXCEL_FILE = 'users.xlsx'

server = Server(AD_SERVER, get_info=ALL)
conn = Connection(server, user=AD_USER, password=AD_PASSWORD, authentication=NTLM, auto_bind=True)

wb = openpyxl.load_workbook(EXCEL_FILE)
sheet = wb.active

for row in sheet.iter_rows(min_row=2, values_only=True):
    first_name, last_name, username, email, ou, password = row

    user_dn = f"CN={first_name} {last_name},{ou}"

    conn.add(
        user_dn,
        ['top','person','organizationalPerson','user'],
        {
            'givenName': first_name,
            'sn': last_name,
            'sAMAccountName': username,
            'userPrincipalName': email
        }
    )

    conn.extend.microsoft.modify_password(user_dn, password)
    conn.modify(user_dn, {'userAccountControl': [(MODIFY_REPLACE, [512])]})

    print(f"Created user: {username}")

conn.unbind()

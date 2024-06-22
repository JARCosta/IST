#!/usr/bin/python3
import psycopg2
import psycopg2.extras



## SGBD configs
DB_HOST="db.tecnico.ulisboa.pt"
DB_USER="istnumber" 
DB_DATABASE=DB_USER
DB_PASSWORD="password"
DB_CONNECTION_STRING = "host=%s dbname=%s user=%s password=%s" % (DB_HOST, DB_DATABASE, DB_USER, DB_PASSWORD)

try:
    dbConn = psycopg2.connect(DB_CONNECTION_STRING)
    cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
    query = "SELECT * FROM account;"
    cursor.execute(query)
    rowcount=cursor.rowcount
    print("Content-type:text/html\r\n\r\n")
    print('<html>')
    print('<head>')
    print('<title> Query Postgres - Python CGI </title>')
    print('</head>')
    print('<body  style="padding:20px">')
    print('<p> Connected to Postgres on <strong>{DB_HOST}</strong> as user <strong>{DB_USER}</strong> on database <strong>{DB_DATABASE}</strong>. </p>'.format(DB_HOST=DB_HOST,DB_USER=DB_USER,DB_DATABASE=DB_DATABASE))
    print('<p> Runing SQL query: <strong>{query}</strong> </p>'.format(query=query))
    print('<p> {rowcount} records retreived:</p>'.format(rowcount=rowcount))
    print('<table border=3">')
    print('  <thead>')
    print('    <tr>')
    print('      <th>account_number</th>')
    print('      <th>branch_name</th>')
    print('      <th>balance</th>')
    print('    </tr>')
    print('  </thead>')
    print('  <tbody>')
    for record in cursor:
        print('<tr>')
        print('  <td>{record}</td>'.format(record=record[0]))
        print('  <td>{record}</td>'.format(record=record[1]))
        print('  <td>{record}</td>'.format(record=record[2]))
        print('</tr>')
    print( '      <tbody>')
    print( '    </table>')
    print( '  </body>')
    print( '</html>')
except Exception as e:
    print( "Content-type:text/html\r\n\r\n")
    print( '<html>')
    print( '<head>')
    print( '<title>Lab 01 - Error running query</title>')
    print( '</head>')
    print( '<body  style="padding:20px">')
    print( '<h1>An error occured</h1>')
    print( '<p>')
    print( e)
    print( '</p>')
    print( '      </body>')
    print( '</html>')


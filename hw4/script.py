import pandas as pd
import sqlalchemy as db
from sqlalchemy import create_engine
from sqlalchemy_utils import database_exists, create_database
from sqlalchemy import Table, Column, Integer, String, MetaData
from sqlalchemy import inspect
import pymysql 
pymysql.install_as_MySQLdb()
import os
from dotenv import load_dotenv
load_dotenv()


# client side programming: python orm
# Create DB
user = 'root'        
pwd = os.getenv('Password')
host = '127.0.0.1'    
port = '3306'        
dbname = 'DB_class'     
conn_str = 'mysql://{user}:{pwd}@{host}:{port}/{dbname}?charset=utf8'.format(
                                                                user=user,
                                                                pwd=pwd,
                                                                host=host,
                                                                port=port,
                                                                dbname=dbname
                                                                )
engine = create_engine(conn_str)
if not database_exists(engine.url):
    create_database(engine.url)
print(database_exists(engine.url))


#Create table
meta = MetaData()
students = Table(
   'students', meta, 
   Column('身份', String(25)), 
   Column('系所', String(25)), 
   Column('年級', Integer),
   Column('學號', String(25), primary_key = True), 
   Column('姓名', String(25)),
)
with engine.connect() as conn:
    meta.create_all(engine)


# Write csv into "DB_class"'s "student" table
# Inspect schema's table to check existence
df = pd.read_csv('DBMS_student_list.csv', index_col=0)
df.to_sql('students', con=engine, if_exists='replace', index=False)
insp = inspect(engine)
print(insp.get_table_names())


with engine.connect() as conn:
    # Select Myself
    myself = students.select().where(students.c.姓名=='呂文楷')
    result = conn.execute(myself).fetchall()[0]
    print(result)

    # List Peer Students
    peer = students.select().where((students.c.年級==1) & (students.c.系所=="資管系") & (students.c.姓名!='呂文楷'))
    results = conn.execute(peer)
    for i in results:
        print(i)
    
# Update
engine = create_engine(conn_str)
conn = engine.connect()
meta = MetaData()
students = Table('students', meta, autoload=True, autoload_with=engine)

query = db.update(students).values(身份 = '特優生').where(students.c.姓名 == '劉謦瑄')
results = conn.execute(query)
results = conn.execute(db.select([students])).fetchall()

print(results)


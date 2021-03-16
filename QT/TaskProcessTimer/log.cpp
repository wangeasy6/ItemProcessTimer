#include "log.h"

#include <QDebug>
#include <QDateTime>
#include <QSqlDatabase>
#include <QSqlError>
#include <QSqlQuery>

Log::Log(QObject *parent) : QObject(parent)
{

}

void initDatabase()
{
    QSqlDatabase database = QSqlDatabase::addDatabase("QSQLITE");
    database.setDatabaseName("TPT.sqlite3");
    if (!database.open())
    {
        qDebug() << "Error: Failed to connect database." << database.lastError();
    }
    else
    {
        qDebug() << "Succeed to connect database." ;
    }

    QSqlQuery sql_query;
    QString is_table_exist = "select count(*) from sqlite_master where name='Task'";
    if(sql_query.exec(is_table_exist))
    {
        if(sql_query.next() && sql_query.value(0).toInt() == 0)
        {
            QString create_table = "create table Task("
                    "task_id text primary key,"
                    "parent_id int,"
                    "task_name text,"
                    "details text,"
                    "estimated_time int,"
                    "create_time datetime)";

            if(!sql_query.exec(create_table))
            {
                qDebug() << "Error: Fail to create table."<< sql_query.lastError();
                return;
            }
            else
            {
                qDebug() << "Table 'Task' created!";
            }
        }
        else {
            qDebug() << "Table 'Task' aleady exist.";
        }
    }
    else
    {
        qDebug() << sql_query.lastError();
        qDebug() << "Find table 'Task' Failed!";
    }

    is_table_exist = "select count(*) from sqlite_master where name='Log'";
    if(sql_query.exec(is_table_exist))
    {
        if(sql_query.next() && sql_query.value(0).toInt() == 0)
        {
            QString create_table = "create table Log("
                                "event_id INTEGER PRIMARY KEY AUTOINCREMENT,"
                                "event_time datetime,"
                                "task_id text NOT NULL,"
                                "operation text,"
                                "details text)";

            if(!sql_query.exec(create_table))
            {
                qDebug() << "Error: Fail to create table."<< sql_query.lastError();
                return;
            }
            else
            {
                qDebug() << "Table 'Log' created!";
            }
        }
        else {
            qDebug() << "Table 'Log' aleady exist.";
        }
    }
    else
    {
        qDebug() << sql_query.lastError();
        qDebug() << "Find table 'Log' Failed!";
    }
}

QString Log::initTask(QString parent_id, QString task_name, QString details, int estimated_time)
{
    QDateTime current_date_time =QDateTime::currentDateTime();
    QString task_id =current_date_time.toString("yyyyMMddhhmmsszzz");

    QString insert_sql = "insert into Task"
             "(task_id,parent_id,task_name,details,estimated_time,create_time) values "
             "(\"" + task_id + "\",\"" + parent_id + "\",\"" \
              + task_name + "\",\"" \
              + details + \
             "\",\"" + QString::number(estimated_time) + \
             "\",\"" + current_date_time.toString("yyyy-MM-dd hh:mm:ss") + "\")";

    qDebug() << "initTask:" << insert_sql;

    QSqlQuery sql_query;
    if(!sql_query.exec(insert_sql))
    {
        qDebug() << "Error: Fail to insert."<< sql_query.lastError();
        return "";
    }

    return task_id;
}

bool Log::write(QString task_id, QString operation, QString details)
{
    QDateTime current_date_time = QDateTime::currentDateTime();

    QString insert_sql = "insert into Log(event_id,event_time,task_id,operation,details) values (NULL,\"" + \
             current_date_time.toString("yyyy-MM-dd hh:mm:ss") + "\",\"" +  \
             task_id + "\",\"" + \
             operation + "\",\"" + details + "\")";

    qDebug() << "write:" << insert_sql;

    QSqlQuery sql_query;
    if(!sql_query.exec(insert_sql))
    {
        qDebug() << "Error: Fail to insert."<< sql_query.lastError();
        return "";
    }
    return true;
}

QStringList Log::read(QString time_start, QString time_end)
{
    QStringList sl;
    return sl;
}

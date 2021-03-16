#ifndef LOG_H
#define LOG_H

#include <QObject>

extern void initDatabase();

class Log : public QObject
{
    Q_OBJECT

public:
    explicit Log(QObject *parent = nullptr);
    Q_INVOKABLE QString initTask(QString parent_id,
                                 QString task_name,
                                 QString details,
                                 int estimated_time);
    Q_INVOKABLE bool write(QString task_id, QString operation, QString details);
    Q_INVOKABLE QStringList read(QString time_start, QString time_end);
};

#endif // LOG_H

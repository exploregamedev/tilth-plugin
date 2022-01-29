tool

extends Reference

class_name DateTime


const nameweekday= ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
const namemonth= ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]

static func str_from_timestamp(timestamp: int) -> String:
    """
    var dayofweek = time["weekday"]   # from 0 to 6 --> Sunday to Saturday
    var day = time["day"]             #   1-31
    var month= time["month"]          #   1-12
    var year= time["year"]            #   2021
    var hour= time["hour"]            #   0-23
    var minute= time["minute"]        #   0-59
    var second= time["second"]        #   0-59

    # support AM/PM
    if hour - 12 < 0:
        meridian = "am"
    else:
        meridian = "pm"
    """
    var date_dict: Dictionary = OS.get_datetime_from_unix_time(timestamp)
    var dayofweek = date_dict["weekday"]
    var day = date_dict["day"]
    var month= date_dict["month"]
    var year= date_dict["year"]
    var hour= date_dict["hour"]
    var minute= date_dict["minute"]
    var second= date_dict["second"]

    # var display_string : String = "%d/%02d/%02d %02d:%02d" % [time.year, time.month, time.day, time.hour, time.minute];
    var dateRFC1123 = "%s, %02d %s %d %02d:%02d:%02d GMT" % [nameweekday[dayofweek], day, namemonth[month-1], year, hour, minute, second]

    return dateRFC1123


static func get_datetime_file_path_string() -> String:
    var date_dict: Dictionary = OS.get_datetime()
    return "%s-%02d-%02dT%02d.%02d.%02d" % [date_dict["year"], date_dict["month"], date_dict["day"],
                                            date_dict["hour"], date_dict["minute"], date_dict["second"]]

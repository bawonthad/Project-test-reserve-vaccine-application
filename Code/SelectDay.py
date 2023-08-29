from datetime import date, timedelta

class SelectDay:
    ROBOT_LIBRARY_SCOPE = 'TEST CASE'
    
    def future_day(self):
        future_day = date.today()+timedelta(days=1)
        formattedday = future_day.strftime('%d/%m/%Y')
        return formattedday

    def present_day(self):
        present_day = date.today()
        formattedday = present_day.strftime('%d/%m/%Y')
        return formattedday
    
    def past_days(self):
        past_days = date.today() - timedelta(days=1)
        formattedday = past_days.strftime('%d/%m/%Y')
        return formattedday
    
    def minus11years(self):
        minus11years = date.today() - timedelta(days=365*11)
        formattedday = minus11years.strftime('%d/%m/%Y')
        return formattedday
    
    def minus12years(self):
        minus12years = date.today() - timedelta(days=365*12)
        formattedday = minus12years.strftime('%d/%m/%Y')
        return formattedday
    
    def minus13years(self):
        minus13years = date.today() - timedelta(days=365*13)
        formattedday = minus13years.strftime('%d/%m/%Y')
        return formattedday
    
        def get_current_date_minusone(self):
            dayminusone = date.today() - timedelta(days=1)
            formattedday = dayminusone.strftime('%d/%m/%Y')
            return formattedday
    
    def get_current_date(self):
        day = date.today()
        formattedday = day.strftime('%d/%m/%Y')
        return formattedday
    
    def get_current_date_plusone(self):
        dayplusone = date.today() + timedelta(days=1)
        formattedday = dayplusone.strftime('%d/%m/%Y')
        return formattedday

    def str_to_int(self, strnum):
        return int(strnum)

    def split_month_and_date(self, month_and_date):
        x = month_and_date.split(" ")
        return x

    def split_str_by_slash(self, inputStr):
        x = inputStr.split("/")
        return x

    def split_str_by_space(self, inputStr):
        x = inputStr.split(" ")
        return x

    def convert_month_to_number(self, month):
        result = 0
        if month == "January":
            result = 1
        elif month == "February":
            result = 2
        elif month == "March":
            result = 3
        elif month == "April":
            result = 4
        elif month == "May":
            result = 5
        elif month == "June":
            result = 6
        elif month == "July":
            result = 7
        elif month == "August":
            result = 8
        elif month == "September":
            result = 9
        elif month == "October":
            result = 10
        elif month == "November":
            result = 11
        elif month == "December":
            result = 12
        return result
    
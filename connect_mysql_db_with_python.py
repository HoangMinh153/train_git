from flask import Flask, jsonify, request
import mysql.connector
import models
import datetime
import os
import cv2
import numpy as np
import ai_face_recog as fr

app = Flask(__name__)

def connect_to_mysql():
    try:
        connection = mysql.connector.connect(host="localhost", port="3306", user="root", password="", database="rollcall")

        if connection.is_connected():
            print("Connected to MySQL database")

        return connection

    except mysql.connector.Error as err:
        print(f"Error: {err}")
        return None

def execute_query(connection, query, data=None):
    try:
        cursor = connection.cursor()

        if data:
            cursor.execute(query, data)
        else:
            cursor.execute(query)

        if cursor.description is not None:
            rows = cursor.fetchall()
        else:
            rows = None

        connection.commit()
        cursor.close()

        return rows

    except mysql.connector.Error as err:
        print(f"Error: {err}")
        return None

def get_data():
    brand_data = request.get_json()

    if not brand_data:
        return jsonify({"error": "No data provided"}), 400
    

@app.route('/get_students', methods=['GET'])
def get_students():
    connection = connect_to_mysql()
    if connection:
        query = "SELECT * FROM students"
        rows = execute_query(connection, query)
        if rows:
            return jsonify(rows)
        else:
            return jsonify({"error": "Failed to fetch data"}), 500
    else:
        return jsonify({"error": "Failed to connect to database"}), 500

@app.route('/add_student', methods=['POST'])
def add_students():
    brand_data = request.get_json()

    if not brand_data:
        return jsonify({"error": "No data provided"}), 400

    student = models.Student(brand_data.get("studentid"), brand_data.get("fullname"),
                             brand_data.get("email"),brand_data.get("phonenumber"),
                             brand_data.get("address"),brand_data.get("dateofbirth"),brand_data.get("gender"),)
    
    if not student.studentid:
        return jsonify({"error": "Brand name is required"}), 400

    connection = connect_to_mysql()
    if connection:
        query = "INSERT INTO students (studentid, fullname, email, phonenumber, address, dateofbirth, gender) VALUES (%s, %s, %s, %s, %s, %s, %s)"
        success = execute_query(connection, query, (student.studentid, student.fullname, student.email, student.phonenumber, student.address, student.dateofbirth, student.gender))
        if success:
            return jsonify({"message": "Brand added successfully"}), 200
        else:
            return jsonify({"error": "Failed to add brand"}), 500
    else:
        return jsonify({"error": "Failed to connect to database"}), 500
    
@app.route('/update_student', methods=['POST'])
def update_students():
    student_data = request.get_json()

    if not student_data:
        return jsonify({"error": "No data provided"}), 400
    
    student_id = student_data.get("studentid")
    if not student_id:
        return jsonify({"error": "Student ID is required"}), 400

    connection = connect_to_mysql()
    if connection:
        
        query_check_existence = "SELECT * FROM students WHERE studentid = %s"
        result = execute_query(connection, query_check_existence, (student_id,))
        if not result:
            return jsonify({"error": "Student does not exist"}), 404

        query_update = "UPDATE students SET fullname = %s, email = %s, phonenumber = %s, address = %s, dateofbirth = %s, gender = %s WHERE studentid = %s"
        success = execute_query(connection, query_update, (student_data.get("fullname"), student_data.get("email"), student_data.get("phonenumber"), student_data.get("address"), student_data.get("dateofbirth"), student_data.get("gender"), student_id))
        if success:
            return jsonify({"message": "Student updated successfully"}), 200
        else:
            return jsonify({"error": "Failed to update student"}), 500
    else:
        return jsonify({"error": "Failed to connect to database"}), 500

@app.route('/get_teacher', methods=['POST'])
def get_teacher():
    try:
        teacher_data = request.get_json()

        if not teacher_data:
            return jsonify({"error": "No data provided"}), 400
        
        teacher_id = teacher_data.get("teacherid")

        if not teacher_id:
            return jsonify({"error": "Teacher ID is required"}), 400

        connection = connect_to_mysql()
        if connection:
            query = "SELECT * FROM teachers WHERE teacherid = %s"
            data = (teacher_id,)
            
            rows = execute_query(connection, query, data)

            if rows:
                return jsonify(rows[0]), 200
            else:
                return jsonify({"error": "Teacher not found"}), 404
        else:
            return jsonify({"error": "Failed to connect to database"}), 500
    except Exception as e:
        return jsonify({"error": f"An error occurred: {str(e)}"}), 500

@app.route('/update_teacher', methods=['POST'])
def update_teacher():
    teacher_data = request.get_json()

    if not teacher_data:
        return jsonify({"error": "No data provided"}), 400
    
    teacher_id = teacher_data.get("teacherid")
    if not teacher_id:
        return jsonify({"error": "Teacher ID is required"}), 400

    connection = connect_to_mysql()
    if connection:
        query_check_existence = "SELECT * FROM teachers WHERE teacherid = %s"
        result = execute_query(connection, query_check_existence, (teacher_id,))
        if not result:
            return jsonify({"error": "Teacher does not exist"}), 404

        query_update = "UPDATE teachers SET username = %s, password = %s, fullname = %s, email = %s, phonenumber = %s, address = %s, dateofbirth = %s, gender = %s WHERE teacherid = %s"
        success = execute_query(connection, query_update, (teacher_data.get("username"), teacher_data.get("password"), teacher_data.get("fullname"), teacher_data.get("email"), teacher_data.get("phonenumber"), teacher_data.get("address"), teacher_data.get("dateofbirth"), teacher_data.get("gender"), teacher_id))
        if success:
            return jsonify({"message": "Teacher updated successfully"}), 200
        else:
            return jsonify({"error": "Failed to update teacher"}), 500
    else:
        return jsonify({"error": "Failed to connect to database"}), 500

@app.route('/get_all_classstudents', methods=['GET'])
def get_all_classstudents():
    try:
        connection = connect_to_mysql()
        if connection:
            query = "SELECT * FROM classstudents"
            
            rows = execute_query(connection, query)

            if rows:
                return jsonify(rows), 200
            else:
                return jsonify({"error": "No classstudents found"}), 404
        else:
            return jsonify({"error": "Failed to connect to database"}), 500
    except Exception as e:
        return jsonify({"error": f"An error occurred: {str(e)}"}), 500
    
@app.route('/add_class_student', methods=['POST'])
def add_class_student():
    
    try:
        class_student_data = request.get_json()

        if not class_student_data:
            return jsonify({"error": "No data provided"}), 400

        class_id = class_student_data.get("classid")
        student_id = class_student_data.get("studentid")
        teacher_id = class_student_data.get("teacherid")

        if not class_id or not student_id or not teacher_id:
            return jsonify({"error": "Missing classid, studentid, or teacherid"}), 400

        connection = connect_to_mysql()

        if connection:
            query = "INSERT INTO classstudents (classid, studentid, teacherid) VALUES (%s, %s, %s)"
            data = (class_id, student_id, teacher_id)

            success = execute_query(connection, query, data)

            if success:
                return jsonify({"message": "Student added to class successfully"}), 200
            else:
                return jsonify({"error": "Failed to add student to class"}), 500
        else:
            return jsonify({"error": "Failed to connect to database"}), 500
    except Exception as e:
        return jsonify({"error": f"An error occurred: {str(e)}"}), 500
    
@app.route('/get_classstudent', methods=['POST'])
def get_classstudent():
    try:
        classstudent_data = request.get_json()

        if not classstudent_data:
            return jsonify({"error": "No data provided"}), 400
        
        teacher_id = classstudent_data.get("teacherid")

        if not teacher_id:
            return jsonify({"error": "Classstudent ID is required"}), 400

        connection = connect_to_mysql()
        if connection:
            query = "SELECT * FROM classstudents WHERE teacherid = %s"
            data = (teacher_id)
            
            rows = execute_query(connection, query, data)

            if rows:
                return jsonify(rows[0]), 200
            else:
                return jsonify({"error": "Classstudent not found"}), 404
        else:
            return jsonify({"error": "Failed to connect to database"}), 500
    except Exception as e:
        return jsonify({"error": f"An error occurred: {str(e)}"}), 500
    
@app.route('/add_attendance', methods=['POST'])
def add_attendance():
    
    try:
        attendance_data = request.get_json()

        if not attendance_data:
            return jsonify({"error": "No data provided"}), 400

        class_student_id = attendance_data.get("classstudentid")
        date = attendance_data.get("date")
        status = attendance_data.get("status")

        if not class_student_id or not date or not status:
            return jsonify({"error": "Missing classstudentid, date, or status"}), 400

        connection = connect_to_mysql()

        if connection:
            query = "INSERT INTO attendance (classstudentid, date, status) VALUES (%s, %s, %s)"
            data = (class_student_id, date, status)

            success = execute_query(connection, query, data)

            if success:
                return jsonify({"message": "Attendance added successfully"}), 200
            else:
                return jsonify({"error": "Failed to add attendance"}), 500
        else:
            return jsonify({"error": "Failed to connect to database"}), 500
    except Exception as e:
        return jsonify({"error": f"An error occurred: {str(e)}"}), 500
    
@app.route('/get_all_attendance', methods=['GET'])
def get_all_attendance():
    try:
        connection = connect_to_mysql()
        if connection:
            query = "SELECT * FROM attendance"
            
            rows = execute_query(connection, query)

            if rows:
                return jsonify(rows), 200
            else:
                return jsonify({"error": "No attendance found"}), 404
        else:
            return jsonify({"error": "Failed to connect to database"}), 500
    except Exception as e:
        return jsonify({"error": f"An error occurred: {str(e)}"}), 500
    from datetime import datetime

@app.route('/get_attendance_by_date', methods=['GET'])
def get_attendance_by_date():
    try:
        # Lấy ngày từ query parameter (nếu có)
        date_str = request.args.get('date')
        
        # Kiểm tra xem ngày có được cung cấp không
        if not date_str:
            return jsonify({"error": "Date parameter is required"}), 400
        
        # Chuyển đổi ngày từ chuỗi thành đối tượng datetime
        try:
            date = datetime.strptime(date_str, "%Y-%m-%d").date()
        except ValueError:
            return jsonify({"error": "Invalid date format. Please use YYYY-MM-DD format"}), 400
        
        connection = connect_to_mysql()
        if connection:
            query = "SELECT * FROM attendance WHERE date = %s"
            data = (date,)
            
            rows = execute_query(connection, query, data)

            if rows:
                return jsonify(rows), 200
            else:
                return jsonify({"error": "No attendance found for the given date"}), 404
        else:
            return jsonify({"error": "Failed to connect to database"}), 500
    except Exception as e:
        return jsonify({"error": f"An error occurred: {str(e)}"}), 500

@app.route('/update_attendance', methods=['PUT'])
def update_attendance():
    attendance_data = request.get_json()

    if not attendance_data:
        return jsonify({"error": "No data provided"}), 400

    class_student_id = attendance_data.get("classstudentid")
    date = attendance_data.get("date")
    status = attendance_data.get("status")
    attendance_id = attendance_data.get("id")
    
    if not class_student_id or not date or not status:
        return jsonify({"error": "Missing classstudentid, date, or status"}), 400

    try:
        connection = connect_to_mysql()
        if connection:
            query = "UPDATE attendance SET classstudentid = %s, date = %s, status = %s WHERE id = %s"
            data = (class_student_id, date, status, attendance_id)

            success = execute_query(connection, query, data)

            if success:
                return jsonify({"message": "Attendance updated successfully"}), 200
            else:
                return jsonify({"error": "Failed to update attendance"}), 500
        else:
            return jsonify({"error": "Failed to connect to database"}), 500
    except Exception as e:
        return jsonify({"error": f"An error occurred: {str(e)}"}), 500

@app.route('/get_classes_by_teacherid', methods=['POST'])
def get_classes_by_teacherid():
    try:
        request_data = request.get_json()

        if not request_data:
            return jsonify({"error": "No data provided"}), 400
        
        teacher_id = request_data.get("teacherid")

        if not teacher_id:
            return jsonify({"error": "Teacher ID is required"}), 400

        connection = connect_to_mysql()
        if connection:
            query = "SELECT * FROM classes WHERE teacherid = %s"
            data = (teacher_id,)
            
            rows = execute_query(connection, query, data)

            if rows:
                return jsonify(rows), 200
            else:
                return jsonify([]), 200  # Trả về danh sách rỗng nếu không tìm thấy lớp
        else:
            return jsonify({"error": "Failed to connect to database"}), 500
    except Exception as e:
        return jsonify({"error": f"An error occurred: {str(e)}"}), 500

UPLOAD_FOLDER = 'E:\\test\\AI_Face\\pic\\'

if not os.path.exists(UPLOAD_FOLDER):
    os.makedirs(UPLOAD_FOLDER)

@app.route('/process_image', methods=['POST'])
def process_image():
    if 'file' not in request.files:
        return jsonify({"error": "No file part"}), 400

    file = request.files['file']

    if file.filename == '':
        return jsonify({"error": "No selected file"}), 400

    filepath = os.path.join(UPLOAD_FOLDER, file.filename)
    file.save(filepath)

    attendance_list = fr.recognition(filepath) #cv2.imread(filepath)
    
    img_bytes = attendance_list[-1]
    attendance_list = [item.split('.')[0] for item in attendance_list[:-1]]
    
    connection = connect_to_mysql()
    if connection:
        classesid = request.get_json().get("classesid")
        query = "SELECT * FROM classstudents WHERE classid = %s;"
            
        rows = execute_query(connection, query,(classesid))

        if rows:
            student_list = []
            for row in rows:
                student = models.Student(row['classstudentid'],)
                student_list.append(student)
        
        for student in student_list:
            for class_student_id in attendance_list:
                if(student.id)
                query = "INSERT INTO attendance (classstudentid, date, status) VALUES (%s, %s, %s)"
                data = (class_student_id, datetime.now(), 1)

                success = execute_query(connection, query, data)

                if success:
                    return jsonify({"message": "Attendance added successfully"}), 200
                else:
                    return jsonify({"error": "Failed to add attendance"}), 500

    uint8list = fr.read_image_to_uint8list(img_bytes)

    return jsonify({"image": str(uint8list)}), 200

if __name__ == '__main__':
    app.run(debug=True)

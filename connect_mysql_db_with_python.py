from flask import Flask, jsonify, request
import mysql.connector
import models
import datetime
import os
import cv2
import numpy as np
import ai_face_recog as face_recog
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

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
            return jsonify({"message": "Student updated successfully"}), 200
    else:
        return jsonify({"error": "Failed to connect to database"}), 500

@app.route('/get_teacher', methods=['POST'])
def get_teacher():
    try:
        teacher_data = request.get_json()

        if not teacher_data:
            return jsonify({"error": "No data provided"}), 400
        
        username = teacher_data.get("username")
        password = teacher_data.get("password")

        if not username:
            return jsonify({"error": "Teacher ID is required"}), 400

        connection = connect_to_mysql()
        if connection:
            query = "SELECT * FROM teachers WHERE username = %s AND password = %s"
            data = (username,password,)
            
            rows = execute_query(connection, query, data)

            if rows:
                return jsonify(rows), 200
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
            return jsonify({"message": "Teacher updated successfully"}), 200
    else:
        return jsonify({"error": "Failed to connect to database"}), 500

@app.route('/get_attendance_date', methods=['POST'])
def get_attendance_date():
    try:
        data = request.get_json()

        if not data:
            return jsonify({"error": "No data provided"}), 400
        
        classid = data.get("classid")

        if not classid:
            return jsonify({"error": "Class ID is required"}), 400

        connection = connect_to_mysql()
        if connection:
            query = "SELECT * FROM attendancedate WHERE classid = %s"
            data = (classid,)
            
            rows = execute_query(connection, query, data)

            if rows:
                return jsonify(rows), 200
            else:
                return jsonify({"error": "Date not found"}), 404
        else:
            return jsonify({"error": "Failed to connect to database"}), 500
    except Exception as e:
        return jsonify({"error": f"An error occurred: {str(e)}"}), 500

@app.route('/get_student_by_id', methods=['POST'])
def get_student_by_id():
    try:
        data = request.get_json()

        if not data:
            return jsonify({"error": "No data provided"}), 400
        
        studentid = data.get("studentid")

        if not studentid:
            return jsonify({"error": "Student ID is required"}), 400

        connection = connect_to_mysql()
        if connection:
            query = "SELECT * FROM students WHERE studentid = %s"
            data = (studentid,)
            
            rows = execute_query(connection, query, data)

            if rows:
                return jsonify(rows), 200
            else:
                return jsonify({"error": "Date not found"}), 404
        else:
            return jsonify({"error": "Failed to connect to database"}), 500
    except Exception as e:
        return jsonify({"error": f"An error occurred: {str(e)}"}), 500
    
@app.route('/get_class_student', methods=['POST'])
def get_class_student():
    try:
        classstudent_data = request.get_json()

        if not classstudent_data:
            return jsonify({"error": "No data provided"}), 400
        
        classid = classstudent_data.get("classid")

        if not classid:
            return jsonify({"error": "Classstudent ID is required"}), 400

        connection = connect_to_mysql()
        if connection:
            query = "SELECT * FROM classstudents WHERE classid = (%s)"
            data = (classid,)
            
            rows = execute_query(connection, query, data)

            if rows:
                return jsonify(rows), 200
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

@app.route('/get_attendance_by_date_and_classid', methods=['POST'])
def get_attendance_by_date_and_classid():
    try:
        attendance_data = request.get_json()

        if not attendance_data:
            return jsonify({"error": "No data provided"}), 400
        date_str = attendance_data.get('date')
        classid = attendance_data.get('classid')
        if not date_str:
            return jsonify({"error": "Date parameter is required"}), 400
        
        connection = connect_to_mysql()
        if connection:
            query = "SELECT * FROM attendance WHERE date = %s and classid = %s"
            data = (date_str,classid,)
            
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
    try:
        if 'file' not in request.files:
            return jsonify({"error": "No file part"}), 400

        file = request.files['file']

        if file.filename == '':
            return jsonify({"error": "No selected file"}), 400

        filepath = os.path.join(UPLOAD_FOLDER, file.filename)
        file.save(filepath)

        attendance_list = face_recog.recognition(filepath) #cv2.imread(filepath)
        
        img_bytes = attendance_list[-1]
        attendance_list = [item.split('.')[0] for item in attendance_list]
        
        connection = connect_to_mysql()
        if connection:
            classesid = request.form.get('classid')
            
            query = "SELECT * FROM classstudents WHERE classid = %s;"
                
            rows = execute_query(connection, query,(classesid,))

            if rows:
                student_list = []
                for row in rows:
                    student = row[2]
                    student_list.append(student)
            
            for student in student_list:
                for class_student_id in attendance_list:
                    if(str(student) == str(class_student_id)):
                        query = "INSERT INTO attendance (classstudentid, date, status) VALUES (%s, %s, %s)"
                        data = (classesid, str(datetime.datetime.now().date()), 1)

                        success = execute_query(connection, query, data)

                        if success:
                            return jsonify({"message": "Attendance added successfully"}), 200
                        else:
                            return jsonify({"error": "Failed to add attendance"}), 500
                        
            query2 = "SELECT * FROM classstudents WHERE classid = %s and date = %s;"
                
            rows2 = execute_query(connection, query,(classesid,str(datetime.datetime.now().date())))

        uint8list = face_recog.read_image_to_uint8list(img_bytes)

        return jsonify({"image": str(uint8list)}), 200

    except Exception as e:
        return jsonify({"error": f"An error occurred: {str(e)}"}), 500
    
# @app.route('/process_image', methods=['POST'])
# def process_image():
#     if 'file' not in request.files:
#         return jsonify({"error": "No file part"}), 400

#     file = request.files['file']

#     if file.filename == '':
#         return jsonify({"error": "No selected file"}), 400

#     filepath = os.path.join(UPLOAD_FOLDER, file.filename)
#     file.save(filepath)

#     attendance_list = face_recog.recognition(filepath) #cv2.imread(filepath)
    
#     img_bytes = attendance_list[-1]
#     attendance_list = [item.split('.')[0] for item in attendance_list]
    
#     connection = connect_to_mysql()
#     if connection:
#         classesid = request.form.get('classid')
        
#         query = "SELECT * FROM classstudents WHERE classid = %s;"
            
#         rows = execute_query(connection, query,(classesid,))

#         if rows:
#             student_list = []
#             for row in rows:
#                 student = row[2]
#                 student_list.append(student)
        
#         for student in student_list:
#             for class_student_id in attendance_list:
#                 if(str(student) == str(class_student_id)):
#                     query = "INSERT INTO attendance (classstudentid, date, status) VALUES (%s, %s, %s)"
#                     data = (classesid, str(datetime.datetime.now().date()), 1)

#                     success = execute_query(connection, query, data)

#                     if success:
#                         return jsonify({"message": "Attendance added successfully"}), 200
#                     else:
#                         return jsonify({"error": "Failed to add attendance"}), 500

#     uint8list = face_recog.read_image_to_uint8list(img_bytes)

#     return jsonify({"image": str(uint8list)}), 200


if __name__ == '__main__':
    app.run(debug=True)

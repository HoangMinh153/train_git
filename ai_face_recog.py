import cv2
import face_recognition
import os
import numpy as np
from datetime import datetime
import json
import AIconfig

def encode_images(images):
    encode_list = []
    for img in images:
        print(img)
        img_rgb = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
        encode = face_recognition.face_encodings(img_rgb)[0]
        encode_list.append(encode)
    return encode_list

def detection():
    path = "E:\\test\\AI_Face\\5"
    images = []
    
    my_list = os.listdir(path)
    for cl in my_list:
        cur_img = cv2.imread(os.path.join(path, cl))
        images.append(cur_img)
        

    encode_list_known = encode_images(images)
    json_file_path = "encode_list_known2.json"

    encode_list_known_jsonable = [encode.tolist() for encode in encode_list_known]

    with open(json_file_path, "w") as json_file:
        json.dump(encode_list_known_jsonable, json_file)
          
    print("Mã hóa thành công")
    print(len(encode_list_known))

def recognition(image_path, classid):
    
    attendance = []
    path = f"E:\\test\\AI_Face\\{classid}"
    class_names = []
    my_list = os.listdir(path)
    for cl in my_list:
        class_names.append(os.path.splitext(cl)[0])
        
    json_file_path = f"E:\\test\\AI_Face\\{classid}.json"

    encode_list_known = []

    with open(json_file_path, "r") as json_file:
        encode_list_known_jsonable = json.load(json_file)
        for encode_jsonable in encode_list_known_jsonable:
            encode_np = np.array(encode_jsonable)
            encode_list_known.append(encode_np)
            
    img = cv2.imread(image_path)
    if img is None:
        print("Không thể đọc ảnh từ đường dẫn.")
        return
    
    img_rgb = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
    face_locations = face_recognition.face_locations(img_rgb)
    face_encodings = face_recognition.face_encodings(img_rgb, face_locations)

    for encode_face, face_loc in zip(face_encodings, face_locations):
        face_distances = face_recognition.face_distance(encode_list_known, encode_face)
        match_index = np.argmin(face_distances)

        if face_distances[match_index] < 0.35:
            name = class_names[match_index].upper()
            attendance.append(name)
            #print("Xác định thành công:", name)
        else:
            name = "Unknown"
            #print("Không nhận dạng được.")

        top, right, bottom, left = face_loc
        cv2.rectangle(img, (left, top), (right, bottom), (0, 255, 0), 2)
        cv2.putText(img, name, (left + 6, top - 6), cv2.FONT_HERSHEY_COMPLEX, 1, (255, 255, 255), 2)

        if name == "Unknown":
            cv2.rectangle(img, (left, top), (right, bottom), (0, 0, 255), 2)

    # screen_width = 1600  
    # screen_height = 900  

    # img_height, img_width, _ = img.shape
    # ratio = min(screen_width / img_width, screen_height / img_height)
    # new_width = int(img_width * ratio)
    # new_height = int(img_height * ratio)

    # img_resized = cv2.resize(img, (new_width, new_height))

    # x_offset = (screen_width - new_width) // 2
    # y_offset = (screen_height - new_height) // 2

    # result_img = np.zeros((screen_height, screen_width, 3), dtype=np.uint8)

    # result_img[y_offset:y_offset+new_height, x_offset:x_offset+new_width] = img_resized

    #cv2.imshow('Recognition Result', result_img)

    current_date = datetime.now().strftime("%Y-%m-%d")

    #image_name = os.path.basename(image_path)
    output_name = f"{current_date}_{classid}.jpg"

    save_dir = "E:\\test\\AI_Face\\pic\\"

    output_path = os.path.join(save_dir, output_name)
    #img.save(output_path)
    os.chdir(save_dir) 
    cv2.imwrite(output_name, img)
    print(f"Ảnh đã được lưu tại: {output_path}")
    
    #attendance.append(output_name)

    # cv2.waitKey(0)
    # cv2.destroyAllWindows()
    
    # return read_image_to_uint8list(output_path)
    return attendance

def read_image_to_uint8list(image_path):
    try:
        img_array = np.fromfile(image_path, dtype=np.uint8)
        
        uint8list = img_array.tobytes()
        
        return uint8list
    except Exception as e:
        print(f"Error: {e}")
        return None

if __name__ == "__main__":
    detection()
    #image_path = "E:\\test\\AI_Face\\pic\\DSC_9594.jpg"
    #print(recognition(image_path))

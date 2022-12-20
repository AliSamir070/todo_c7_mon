import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_c7_mon/model/TodoDM.dart';
import 'package:todo_c7_mon/providers/list_provider.dart';
import 'package:todo_c7_mon/ui/comman/update_field.dart';

class UpdateScreen extends StatefulWidget {
  static String routename = "UpdateScreen";

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  late TextEditingController titleController;

  late TextEditingController descController;
  var formKey = GlobalKey<FormState>();
  late ListProvider provider;
  @override
  Widget build(BuildContext context) {
    provider = Provider.of(context);
    TodoDM todo = ModalRoute.of(context)!.settings.arguments as TodoDM;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    titleController = TextEditingController(text:todo.title );
    descController = TextEditingController(text: todo.description);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                AppBar(
                  title: Text(
                      "To Do List"
                  ),
                  flexibleSpace: SizedBox(height: height*0.2,),
                ),
                Container(
                  padding: EdgeInsetsDirectional.all(20),
                  margin: EdgeInsets.symmetric(vertical: height*0.12,horizontal: width*0.05),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Edit Task" , style: Theme.of(context).textTheme.bodySmall,),
                        SizedBox(height: height*0.1,),
                        UpdateField("title", titleController, TextInputType.text ,
                              (value){
                          todo.title = value;
                        },
                            (value){
                              if(value!.isEmpty){
                                return "Title shouldn't be empty";
                              }
                              return null;
                            }
                        ),
                        SizedBox(height: height*0.01,),
                        UpdateField("description", descController, TextInputType.multiline,
                                (value){
                              todo.description = value;
                            },
                                (value){
                              if(value!.isEmpty){
                                return "Description shouldn't be empty";
                              }
                              return null;
                            }
                        ),
                        SizedBox(height: height*0.04,),
                        Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Text("Select Time" ,style: Theme.of(context).textTheme.bodyMedium )),
                        SizedBox(height: height*0.02,),
                        InkWell(
                          onTap: (){
                            showPicker(todo);
                          },
                          child: Text(
                            "${todo.date.day}-${todo.date.month}-${todo.date.year}",
                              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                color: Colors.grey
                              )
                          ),
                        ),
                        SizedBox(height: height*0.2,),
                        ElevatedButton(
                            onPressed: (){
                              if(formKey.currentState!.validate()){
                                provider.UpdateTodoToFirestore(todo);
                              }
                            },
                            child: Text("Save Changes"),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadiusDirectional.circular(20)
                              )
                            ),)
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void showPicker(TodoDM todo){
    showDatePicker(
        context: context,
        initialDate: todo.date,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 365)),
    ).then((value){
      todo.date = value??todo.date;
      setState((){});
    });
  }
}

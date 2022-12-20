import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:todo_c7_mon/model/TodoDM.dart';
import 'package:todo_c7_mon/providers/list_provider.dart';
import 'package:todo_c7_mon/ui/screens/update_screen.dart';
import 'package:todo_c7_mon/utils/my_theme_data.dart';

class TodoItem extends StatelessWidget {
  TodoDM todo;
  TodoItem(this.todo);
  late ListProvider provider ;
  @override
  Widget build(BuildContext context) {
    provider = Provider.of(context);
    return Slidable(
      startActionPane: ActionPane(
        motion: ScrollMotion(),
        children: [
          SlidableAction(onPressed: (_){
            FirebaseFirestore.instance.collection("todos").doc(todo.id)
                .delete().timeout(Duration(milliseconds: 500), onTimeout: (){
                 provider.getTodosFromFirestore();
                });
          },
            label: "Delete",
            icon: Icons.delete,
            backgroundColor: Colors.red,
            borderRadius: BorderRadius.circular(12),
            flex: 2,

          )
        ],
      ),
      child: InkWell(
        onTap: (){
          Navigator.pushNamed(context, UpdateScreen.routename , arguments: todo);
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 25, horizontal: 16),
          margin: EdgeInsets.all(18),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12)
          ),
          child: Row(
            children: [
              Container(color: todo.isDone?MyThemeData.lightGreen:Theme.of(context).primaryColor, height: 50, width:6,),
              Spacer(),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(todo.title,
                       textAlign: TextAlign.start,
                      style: todo.isDone?Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: MyThemeData.lightGreen
                      ):Theme.of(context).textTheme.titleMedium,),
                    SizedBox(height: 12,),
                    Text(todo.description,
                      style: Theme.of(context).textTheme.titleSmall,),
                  ],
                ),
              ),
              Spacer(),
              InkWell(
                onTap: (){
                  if(!todo.isDone){
                    provider.UpdateDone(todo);
                  }
                },
                child: todo.isDone
                    ?Text("Done!" , style: Theme.of(context).textTheme.headlineSmall,)
                    :Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(12)
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),

                    child: Image.asset("assets/ic_check.png")),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

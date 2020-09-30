import 'package:flutter/material.dart';
import '../dummy_data.dart';

class MealDetailScreen extends StatelessWidget {
  static final routeName = "/meal-detail";

  Widget _buildTitleText(BuildContext ctx, String text) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Text(
        text,
        style: Theme.of(ctx).textTheme.headline6,
      ),
    );
  }

  Widget _buildContainer(BuildContext ctx, Widget widget) {
    return Container(
      height: 200,
      width: 300,
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: widget,
    );
  }

  @override
  Widget build(BuildContext context) {
    final mealId = ModalRoute.of(context).settings.arguments as String;

    final selectedMealItem =
        DUMMY_MEALS.firstWhere((meal) => mealId == meal.id);
    return Scaffold(
      appBar: AppBar(title: Text("${selectedMealItem.title}")),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 300,
              width: double.infinity,
              child: Image.network(
                selectedMealItem.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            _buildTitleText(context, "Ingredients"),
            _buildContainer(
                context,
                ListView.builder(
                  itemBuilder: (ctx, index) {
                    return Card(
                      color: Theme.of(ctx).accentColor,
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: Text(selectedMealItem.ingredients[index]),
                      ),
                    );
                  },
                  itemCount: selectedMealItem.ingredients.length,
                )),
            _buildTitleText(context, "Steps"),
            _buildContainer(
                context,
                ListView.builder(
                  itemBuilder: (ctx, index) {
                    return Column(
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            child: Text("# ${index + 1}"),
                          ),
                          title: Text(selectedMealItem.steps[index]),
                        ),
                        Divider()
                      ],
                    );
                  },
                  itemCount: selectedMealItem.steps.length,
                )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.delete),
        onPressed: (){
          Navigator.of(context).pop(mealId);
        },
      ),
    );
  }
}

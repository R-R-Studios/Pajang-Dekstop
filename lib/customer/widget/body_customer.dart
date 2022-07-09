import 'package:beben_pos_desktop/customer/datasource/data_source_customer.dart';
import 'package:beben_pos_desktop/model/head_column_model.dart';
import 'package:beben_pos_desktop/customer/model/customer_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BodyCustomer extends StatefulWidget {
  final List<HeadColumnModel> checkBoxModel;
  final List<CustomerModel> customerModel;
  BodyCustomer(this.customerModel, this.checkBoxModel);

  @override
  _BodyCustomerState createState() => _BodyCustomerState();
}

class _BodyCustomerState extends State<BodyCustomer> {

  late List<CustomerModel> _customerModel = widget.customerModel;
  late List<HeadColumnModel> _checkboxModel = widget.checkBoxModel;
  int _currentSortColumn = 0;
  bool _isAscending = true;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(top: 10),
        child: ListView(
          shrinkWrap: true,
          children: [
            PaginatedDataTable(
              header: Text("Customer"),
              sortColumnIndex: _currentSortColumn,
              sortAscending: _isAscending,
              columnSpacing: 0,
              horizontalMargin: 0,
              rowsPerPage: _customerModel.length > 5 ? 5 : _customerModel.length,
              columns: <DataColumn>[
                for(final header in _checkboxModel)
                  DataColumn(
                      label: Text(header.name!),
                      tooltip: header.name,
                      onSort: (columnIndex, _sortAscending){
                        setState(() {
                          _currentSortColumn = columnIndex;
                          if(_currentSortColumn == 0){
                            _sortId();
                          }else if(_currentSortColumn == 1){
                            _sortFirstName();
                          }else if(_currentSortColumn == 2){
                            _sortLastName();
                          }else if(_currentSortColumn == 3){
                            _sortEmail();
                          }else if(_currentSortColumn == 4){
                            _sortPhoneNumber();
                          }else if(_currentSortColumn == 5){
                            _sortTotalSpent();
                          }
                        });
                      }
                  ),
                DataColumn(label: Center(child: Text(""))),
                DataColumn(label: Text("")),
              ], source: DataSourceCustomer(context, _customerModel),
            )
          ],
        )
    );
  }

  void _sortId() {
    if (_isAscending == true) {
      _isAscending = false;
      // sort the product list in Ascending, order by Price
      _customerModel.sort((idA, idB) =>
          idA.id!.compareTo(idB.id!));
    } else {
      _isAscending = true;
      // sort the product list in Descending, order by Price
      _customerModel.sort((idA, idB) =>
          idB.id!.compareTo(idA.id!));
    }
  }

  void _sortFirstName() {
    if (_isAscending == true) {
      _isAscending = false;
      // sort the product list in Ascending, order by Price
      _customerModel.sort((idA, idB) =>
          idA.firstName!.compareTo(idB.firstName!));
    } else {
      _isAscending = true;
      // sort the product list in Descending, order by Price
      _customerModel.sort((idA, idB) =>
          idB.firstName!.compareTo(idA.firstName!));
    }
  }

  void _sortLastName() {
    if (_isAscending == true) {
      _isAscending = false;
      // sort the product list in Ascending, order by Price
      _customerModel.sort((idA, idB) =>
          idA.lastName!.compareTo(idB.lastName!));
    } else {
      _isAscending = true;
      // sort the product list in Descending, order by Price
      _customerModel.sort((idA, idB) =>
          idB.lastName!.compareTo(idA.lastName!));
    }
  }

  void _sortEmail() {
    if (_isAscending == true) {
      _isAscending = false;
      // sort the product list in Ascending, order by Price
      _customerModel.sort((idA, idB) =>
          idA.email!.compareTo(idB.email!));
    } else {
      _isAscending = true;
      // sort the product list in Descending, order by Price
      _customerModel.sort((idA, idB) =>
          idB.email!.compareTo(idA.email!));
    }
  }

  void _sortPhoneNumber() {
    if (_isAscending == true) {
      _isAscending = false;
      // sort the product list in Ascending, order by Price
      _customerModel.sort((idA, idB) =>
          idA.phoneNumber!.compareTo(idB.phoneNumber!));
    } else {
      _isAscending = true;
      // sort the product list in Descending, order by Price
      _customerModel.sort((idA, idB) =>
          idB.phoneNumber!.compareTo(idA.phoneNumber!));
    }
  }

  void _sortTotalSpent() {
    if (_isAscending == true) {
      _isAscending = false;
      // sort the product list in Ascending, order by Price
      _customerModel.sort((idA, idB) =>
          idA.totalSpent!.compareTo(idB.totalSpent!));
    } else {
      _isAscending = true;
      // sort the product list in Descending, order by Price
      _customerModel.sort((idA, idB) =>
          idB.totalSpent!.compareTo(idA.totalSpent!));
    }
  }
}
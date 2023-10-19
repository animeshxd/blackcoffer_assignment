import 'package:flutter/material.dart';
import 'package:intl_phone_field/countries.dart';

class CountrySearchDelegate extends SearchDelegate<Country> {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    var query_ = RegExp(query, caseSensitive: false);
    var result = countries
        .where((element) =>
            ((query.length > 2 && element.name.contains(query_)) ||
                element.fullCountryCode.contains(query_)) ||
            element.code.contains(query_))
        .toList();

    return ListView.separated(
      itemBuilder: (context, index) {
        var country = result[index];
        return listTileFromCode(context, country);
      },
      separatorBuilder: (context, index) => const Divider(),
      itemCount: result.length,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) {
        late Country country = countries[index];

        return listTileFromCode(context, country);
      },
      separatorBuilder: (context, index) => const Divider(),
      itemCount: countries.length,
    );
  }

  ListTile listTileFromCode(BuildContext context, Country country) {
    return ListTile(
      onTap: () => close(context, country),
      subtitle: Text(country.code),
      leading: Text(
        country.flag,
        style: const TextStyle(fontSize: 15),
      ),
      title: Text(
        country.name,
        style: const TextStyle(fontSize: 15),
      ),
      trailing: Text('+${country.fullCountryCode}'),
    );
  }
}

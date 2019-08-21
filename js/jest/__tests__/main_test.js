'use strict';

import {CleanLocalizationClient} from "../../src/clean_localization_client";

it('translates simple key (when missing key)', () => {
  const key = 'key';
  const value = CleanLocalizationClient.t(key);
  expect(value).toEqual('');
});

it('translates simple key (when key exists)', () => {
  const key = 'key';
  CleanLocalizationClient.db.data[key] = 'ok';

  const value = CleanLocalizationClient.t(key);
  expect(value).toEqual('ok');
});

it('translates complex key', () => {
  const key = 'key';
  const dataValue = 'value is %{first} <b>%{second}</b>!';
  CleanLocalizationClient.db.data[key] = dataValue;

  const value = CleanLocalizationClient.translate(key, { first: 'hello', second: 'world' });
  expect(value).toEqual('value is hello <b>world</b>!');
});

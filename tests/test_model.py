from unittest import TestCase

from followthemoney.proxy import EntityProxy

from ftm_geocode import model


class ModelTestCase(TestCase):
    def test_model(self):
        address = """
            OpenStreetMap Foundation
            St John’s Innovation Centre
            Cowley Road
            Cambridge
            CB4 0WS
            United Kingdom
        """
        address = model.Address.from_string(address)
        self.assertDictEqual(
            address.to_dict(),
            {
                "remarks": ["Openstreetmap Foundation St John'S Innovation Centre"],
                "street": ["Cowley Road"],
                "city": ["Cambridge"],
                "postalCode": ["Cb4 0Ws"],
                "country": ["GB"],
            },
        )

        proxy = address.to_proxy()
        self.assertIsInstance(proxy, EntityProxy)
        self.assertDictEqual(
            proxy.to_dict(),
            {
                "id": "addr-gb-c0e5062177a485e1881fcfbd2210d6d7f1d2d3bd",
                "schema": "Address",
                "properties": {
                    "remarks": ["Openstreetmap Foundation St John'S Innovation Centre"],
                    "street": ["Cowley Road"],
                    "city": ["Cambridge"],
                    "postalCode": ["Cb4 0Ws"],
                    "country": ["GB"],
                },
            },
        )

        # less info, not so good result
        address = "DUDA-EPURENI, 737230, RO"
        address = model.Address.from_string(address, country="ro")
        address = address.to_dict()
        address["remarks"] = list(sorted(address["remarks"]))
        self.assertDictEqual(
            address,
            {
                "remarks": ["737230", "Duda-Epureni"],
                "street": ["Ro"],
                "country": ["RO"],
            },
        )

        # we store postal result to access it later
        address = """
            OpenStreetMap Foundation
            St John’s Innovation Centre
            Cowley Road
            Cambridge
            CB4 0WS
            United Kingdom
        """
        address = model.Address.from_string(address)
        self.assertIsInstance(address._postal, model.PostalAddress)
        self.assertEqual(
            address._postal.to_dict(),
            {
                "country_code": "GB",
                "house": "Openstreetmap Foundation St John'S Innovation Centre",
                "road": "Cowley Road",
                "postcode": "Cb4 0Ws",
                "city": "Cambridge",
                "country": "United Kingdom",
            },
        )
